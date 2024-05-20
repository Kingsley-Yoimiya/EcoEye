from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from .models import Record, Advice
from .serializers import RecordSerializer, AdviceSerializer
from rest_framework.authtoken.models import Token
import os
from django.conf import settings
from django.utils import timezone
from kaggle_model.model import predict

class HistoryView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, userId):
        user = request.user
        # Ensure token matches the user
        if not Token.objects.filter(user=user, key=request.auth.key).exists():
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)

        records = Record.objects.filter(userId=userId).order_by('timestamp')
        serializer = RecordSerializer(records, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class ResultView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, recordId):
        user = request.user
        try:
            record = Record.objects.get(id=recordId, userId=str(user.id))
        except Record.DoesNotExist:
            return Response({"message": "Record not found"}, status=status.HTTP_404_NOT_FOUND)
        
        # 检查 analysisResults 字段是否为空
        if not record.analysisResults:
            file_path = os.path.join(settings.MEDIA_ROOT, record.photo.name)
            analysis_result = str(predict(file_path))
            
            print(analysis_result)

            # 更新记录的分析结果
            record.analysisResults = {"resultText": analysis_result, "resultImage": self._build_full_photo_url(request, record.photo.name)}
            record.save()
            return Response({
                "recordId": record.id,
                "photo": record.analysisResults["resultImage"],
                "analysisResults": record.analysisResults["resultText"],
                "timestamp": record.timestamp.isoformat(),
                "status": "Success"
            }, status=status.HTTP_200_OK)
        else:
            # 如果 analysisResults 已存在，直接返回
            return Response({
                "recordId": record.id,
                "photo": self._build_full_photo_url(request, record.photo.name),
                "analysisResults": record.analysisResults["resultText"],
                "timestamp": record.timestamp.isoformat(),
                "status": "Success"
            }, status=status.HTTP_200_OK)
    
    def _build_full_photo_url(self, request, photo_name):
        return request.build_absolute_uri(settings.MEDIA_URL + photo_name)

class AdviceView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, recordId):
        user = request.user
        # Ensure token matches the user
        if not Token.objects.filter(user=user, key=request.auth.key).exists():
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)

        try:
            record = Record.objects.get(id=recordId, userId=user.id)
        except Record.DoesNotExist:
            return Response({"message": "Record not found"}, status=status.HTTP_404_NOT_FOUND)
        
        advice, created = Advice.objects.get_or_create(record=record, defaults={'adviceText': "This is an example advice text.", 'timestamp': timezone.now()})
        if not created and record.timestamp > advice.timestamp:
            advice.adviceText = "This is an example advice text."
            advice.timestamp = timezone.now()
            advice.save()

        return Response({
            "recordId": record.id,
            "adviceText": advice.adviceText,
            "adviceTimestamp": advice.timestamp.isoformat(),
            "status": "Success"
        }, status=status.HTTP_200_OK)

class DeleteView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def delete(self, request, recordId):
        user = request.user
        try:
            record = Record.objects.get(id=recordId, userId=str(user.id))
            record.delete()
            return Response({"message": "Record deleted successfully"}, status=status.HTTP_204_NO_CONTENT)
        except Record.DoesNotExist:
            return Response({"message": "Record not found"}, status=status.HTTP_404_NOT_FOUND)

class ReanalyzeView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def put(self, request, recordId):
        user = request.user
        try:
            record = Record.objects.get(id=recordId, userId=str(user.id))
            new_analysis_result = str(predict(os.path.join(settings.MEDIA_ROOT, record.photo.name)))
            record.analysisResults = {"resultText": new_analysis_result, "resultImage": self._build_full_photo_url(request, record.photo.name)}
            record.timestamp = timezone.now()
            record.save()
            return Response({
                "recordId": record.id,
                "analysisResults": record.analysisResults["resultText"],
                "photo": self._build_full_photo_url(request, record.photo.name),
                "timestamp": record.timestamp.isoformat(),
                "status": "Success"
            }, status=status.HTTP_200_OK)
        except Record.DoesNotExist:
            return Response({"message": "Record not found"}, status=status.HTTP_404_NOT_FOUND)
    
    def _build_full_photo_url(self, request, photo_name):
        return request.build_absolute_uri(settings.MEDIA_URL + photo_name)

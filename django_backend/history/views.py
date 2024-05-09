from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from .models import Record, Advice
from .serializers import RecordSerializer, AdviceSerializer
from rest_framework.authtoken.models import Token
import base64
import os
from django.conf import settings

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
            # 直接生成示例分析结果，包括图片的完整 URL
            example_analysis_results = {
                "resultText": "This is an example analysis result.",
                "resultImage": self._build_full_photo_url(request, record.photo.name),
                "analysisResults": {},  # 示例为空的分析结果
            }
            record.analysisResults = example_analysis_results
            record.save()
            return Response({
                "recordId": record.id,
                "photo": example_analysis_results["resultImage"],
                "analysisResults": example_analysis_results["analysisResults"],
                "timestamp": record.timestamp.isoformat(),
                "status": "Success"
            }, status=status.HTTP_200_OK)
        else:
            # 如果 analysisResults 已存在，直接返回
            return Response({
                "recordId": record.id,
                "photo": self._build_full_photo_url(request, record.photo.name),
                "analysisResults": record.analysisResults,
                "timestamp": record.timestamp.isoformat(),
                "status": "Success"
            }, status=status.HTTP_200_OK)
    
    def _build_full_photo_url(self, request, photo_name):
        """
        构建图片的完整 URL。
        """
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

        advice = Advice.objects.filter(record_id=recordId)
        serializer = AdviceSerializer(advice, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

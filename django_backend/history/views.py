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
from django.utils import timezone

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
            record.analysisResults = example_analysis_results["resultText"]
            record.save()
            return Response({
                "recordId": record.id,
                "photo": example_analysis_results["resultImage"],
                "analysisResults": example_analysis_results["resultText"],
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
        # 确保令牌匹配用户
        if not Token.objects.filter(user=user, key=request.auth.key).exists():
            return Response({"message": "Unauthorized access"}, status=status.HTTP_401_UNAUTHORIZED)

        try:
            # 检查记录是否存在
            record = Record.objects.get(id=recordId, userId=user.id)
        except Record.DoesNotExist:
            return Response({"message": "Record not found"}, status=status.HTTP_404_NOT_FOUND)
        
        # 尝试获取与此记录相关的建议
        advice, created = Advice.objects.get_or_create(record=record, defaults={'adviceText': "This is an example advice text.", 'timestamp': timezone.now()})
        
        # 如果建议已经存在但记录有更新，则更新建议
        if not created and record.timestamp > advice.timestamp:
            advice.adviceText = "This is an example advice text."
            advice.timestamp = timezone.now()
            advice.save()

        # 返回相关一系列信息
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
            # 假设重新分析的结果
            new_analysis_result = "This is the new result." + str(timezone.now())
            record.analysisResults = new_analysis_result
            record.timestamp = timezone.now()  # 更新时间戳
            record.save()
            return Response({
                "recordId": record.id,
                "analysisResults": new_analysis_result,
                "photo": self._build_full_photo_url(request, record.photo.name),
                "timestamp": record.timestamp.isoformat(),
                "status": "Success"
            }, status=status.HTTP_200_OK)
        except Record.DoesNotExist:
            return Response({"message": "Record not found"}, status=status.HTTP_404_NOT_FOUND)
    
    def _build_full_photo_url(self, request, photo_name):
        return request.build_absolute_uri(settings.MEDIA_URL + photo_name)

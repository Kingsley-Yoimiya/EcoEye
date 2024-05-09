import logging
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.core.files.storage import default_storage
from django.utils.text import get_valid_filename
from django.conf import settings
from history.models import Record
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone

logger = logging.getLogger(__name__)

class UploadView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request):
        file = request.FILES.get('photo')
        if file:
            try:
                valid_filename = get_valid_filename(file.name)
                file_name = default_storage.save(valid_filename, file)
                # 使用 request.user 获取当前认证的用户对象
                user = request.user
                # 假设 User 模型的 ID 是我们需要的 userId
                userId = user.id
                record = Record.objects.create(userId=str(userId), photo=file_name, timestamp=timezone.now())
                return Response({"message": "File uploaded successfully", "file": file_name, "recordId": record.id}, status=status.HTTP_200_OK)
            except Exception as e:
                logger.error(f"Error uploading file: {str(e)}")
                return Response({"message": f"Failed to upload file: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        return Response({"message": "No file uploaded"}, status=status.HTTP_400_BAD_REQUEST)
    
class AnalysisView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user
        photo = request.data.get('photo')
        if photo:
            # Simulate analysis process
            analysis_results = {"result": "positive", "confidence": 95}
            # Save record to database
            record = Record.objects.create(userId=user.id, photo=photo, analysisResults=analysis_results)
            return Response({"message": "Analysis completed", "analysis_results": analysis_results, "recordId": record.id}, status=status.HTTP_200_OK)
        return Response({"message": "No photo provided"}, status=status.HTTP_400_BAD_REQUEST)

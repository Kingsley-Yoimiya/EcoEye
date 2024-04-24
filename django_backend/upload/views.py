from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.core.files.storage import default_storage

class UploadView(APIView):
    def post(self, request):
        file = request.FILES.get('photo')
        if file:
            file_name = default_storage.save(file.name, file)
            return Response({"message": "File uploaded successfully", "file": file_name}, status=status.HTTP_200_OK)
        return Response({"message": "No file uploaded"}, status=status.HTTP_400_BAD_REQUEST)

class AnalysisView(APIView):
    def post(self, request):
        # 这里应该是分析图片的逻辑，我们简单模拟返回一些分析结果
        # 在实际应用中，这里可以调用机器学习模型或外部API进行图片分析
        photo = request.data.get('photo')
        if photo:
            # 模拟分析过程
            analysis_results = {"result": "positive", "confidence": 95}
            return Response({"message": "Analysis completed", "analysis_results": analysis_results}, status=status.HTTP_200_OK)
        return Response({"message": "No photo provided"}, status=status.HTTP_400_BAD_REQUEST)

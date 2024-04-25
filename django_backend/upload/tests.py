# upload/tests.py

from django.test import TestCase
from django.core.files.uploadedfile import SimpleUploadedFile
from rest_framework.test import APIClient
from rest_framework import status

class UploadViewTest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.upload_url = '/api/upload/upload/'  # 确保这个 URL 与你在 urls.py 中定义的一致

    def test_file_upload(self):
        """
        测试文件上传功能
        """
        # 创建一个简单的测试文件
        test_file = SimpleUploadedFile("test_file.jpg", b"file_content", content_type="image/jpeg")
        response = self.client.post(self.upload_url, {'photo': test_file}, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("File uploaded successfully", response.data["message"])
class AnalysisViewTest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.analysis_url = '/api/upload/analyze/'  # 确保这个 URL 与你在 urls.py 中定义的一致

    def test_file_analysis(self):
        """
        测试文件分析功能
        """
        # 假设分析请求需要文件名作为输入
        response = self.client.post(self.analysis_url, {'photo': 'test_file.jpg'}, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("Analysis completed", response.data["message"])
        # 这里可以添加更多的断言来检查分析结果的具体内容


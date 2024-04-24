# share/tests.py

from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status

class ShareViewTest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.share_url = '/api/share/share/'  # 确保这个 URL 与你在 urls.py 中定义的一致

    def test_share_content(self):
        """
        测试分享内容的 API
        """
        # 模拟分享请求的数据
        share_data = {
            'platform': 'Twitter',
            'content': '这是一条测试分享内容'
        }
        response = self.client.post(self.share_url, share_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, {"message": "Content shared successfully"})

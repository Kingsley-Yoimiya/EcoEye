# history/tests.py 或 history/test_models.py

from django.test import TestCase
from .models import Record, Advice
from django.utils import timezone

class RecordModelTest(TestCase):
    def setUp(self):
        # 创建一个测试记录
        self.record = Record.objects.create(userId="testuser", photo="test_photo.jpg", analysisResults={"result": "positive"}, timestamp=timezone.now())

    def test_record_creation(self):
        self.assertTrue(isinstance(self.record, Record))
        self.assertEqual(self.record.__str__(), f"Record {self.record.id} for User {self.record.userId}")

class AdviceModelTest(TestCase):
    def setUp(self):
        # 首先创建一个测试记录
        record = Record.objects.create(userId="testuser", photo="test_photo.jpg", analysisResults={"result": "positive"}, timestamp=timezone.now())
        # 使用这个记录创建一个测试建议
        self.advice = Advice.objects.create(record=record, adviceText="Keep it dry", timestamp=timezone.now())

    def test_advice_creation(self):
        self.assertTrue(isinstance(self.advice, Advice))
        self.assertEqual(self.advice.__str__(), f"Advice {self.advice.id} for Record {self.advice.record.id}")

# 继续在 history/tests.py 或创建 history/test_views.py

from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient

class HistoryViewTest(TestCase):
    def setUp(self):
        self.client = APIClient()
        # 创建测试数据
        self.record = Record.objects.create(userId="testuser", photo="test_photo.jpg", analysisResults={"result": "positive"}, timestamp=timezone.now())

    def test_get_history(self):
        response = self.client.get(reverse('history', kwargs={'userId': 'testuser'}))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)  # 假设只有一个记录

class AdviceViewTest(TestCase):
    def setUp(self):
        self.client = APIClient()
        record = Record.objects.create(userId="testuser", photo="test_photo.jpg", analysisResults={"result": "positive"}, timestamp=timezone.now())
        self.advice = Advice.objects.create(record=record, adviceText="Keep it dry", timestamp=timezone.now())

    def test_get_advice(self):
        response = self.client.get(reverse('advice', kwargs={'recordId': self.advice.record.id}))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)  # 假设只有一个建议


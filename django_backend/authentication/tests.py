from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework import status
from .models import User

class AuthenticationTestCase(APITestCase):
    def test_registration(self):
        """
        测试用户注册
        """
        data = {"username": "testuser", "email": "test@example.com", "password": "testpassword"}
        response = self.client.post(reverse('register'), data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_login(self):
        """
        测试用户登录
        """
        self.test_registration()  # 先注册一个用户
        data = {"username": "testuser", "password": "testpassword"}
        response = self.client.post(reverse('login'), data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

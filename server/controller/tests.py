# controller/tests.py

from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework import status
from django.contrib.auth.models import User

class UserManagementTests(APITestCase):
    def test_user_registration(self):
        """
        Ensure we can create a new user.
        """
        url = reverse('register')
        data = {'username': 'testuser', 'password': 'testpassword123', 'email': 'test@example.com'}
        response = self.client.post(url, data, format='json')
        
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(User.objects.get().username, 'testuser')


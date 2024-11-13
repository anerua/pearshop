from django.urls import reverse
from django.contrib.auth.models import User
from rest_framework.test import APITestCase
from rest_framework import status

class LoginTests(APITestCase):
    def setUp(self):
        # Create a test user
        self.user = User.objects.create_user(
            username='testuser',
            password='testpass123'
        )
        self.url = reverse('token_obtain_pair')

    def test_login_successful(self):
        """
        Ensure we can login with valid credentials
        """
        data = {
            'username': 'testuser',
            'password': 'testpass123'
        }
        response = self.client.post(self.url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)

    def test_login_invalid_username(self):
        """
        Ensure login fails with invalid username
        """
        data = {
            'username': 'wronguser',
            'password': 'testpass123'
        }
        response = self.client.post(self.url, data)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_login_invalid_password(self):
        """
        Ensure login fails with invalid password
        """
        data = {
            'username': 'testuser',
            'password': 'wrongpass'
        }
        response = self.client.post(self.url, data)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_login_missing_fields(self):
        """
        Ensure login fails when fields are missing
        """
        # Missing password
        response = self.client.post(self.url, {'username': 'testuser'})
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

        # Missing username
        response = self.client.post(self.url, {'password': 'testpass123'})
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

        # Empty request
        response = self.client.post(self.url, {})
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

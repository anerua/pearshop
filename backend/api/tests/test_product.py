from django.urls import reverse
from django.contrib.auth.models import User
from rest_framework.test import APITestCase
from rest_framework import status

from api.models import Product

class ProductListTests(APITestCase):
    def setUp(self):
        # Create a test user and admin user
        self.user = User.objects.create_user(username='testuser', password='testpass123')
        self.admin = User.objects.create_superuser(username='admin', password='admin123')
        
        # Create some test products
        self.products = [
            Product.objects.create(
                name=f'Test Product {i}',
                price=1000 * i,
                description=f'Description for product {i}'
            ) for i in range(1, 4)
        ]
        
        # URL for product list
        self.url = reverse('list_or_create_product')

    def test_get_product_list_unauthenticated(self):
        """
        Ensure we can get product list without authentication
        """
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

    def test_get_product_list_authenticated(self):
        """
        Ensure authenticated users can get product list
        """
        self.client.force_authenticate(user=self.user)
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 3)

    def test_create_product_as_admin(self):
        """
        Ensure admin users can create products
        """
        self.client.force_authenticate(user=self.admin)
        data = {
            'name': 'New Product',
            'price': 2000,
            'description': 'New product description'
        }
        response = self.client.post(self.url, data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Product.objects.count(), 4)
        self.assertEqual(response.data['name'], 'New Product')

    def test_create_product_as_regular_user(self):
        """
        Ensure regular users cannot create products
        """
        self.client.force_authenticate(user=self.user)
        data = {
            'name': 'New Product',
            'price': 2000,
            'description': 'New product description'
        }
        response = self.client.post(self.url, data)
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(Product.objects.count(), 3)
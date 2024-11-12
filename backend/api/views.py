from django.contrib.auth.models import User
from rest_framework.generics import CreateAPIView, ListCreateAPIView, RetrieveUpdateDestroyAPIView, RetrieveAPIView
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import BasePermission, IsAuthenticated, IsAdminUser, SAFE_METHODS

from .models import *
from .serializers import *


class ReadOnly(BasePermission):
    def has_permission(self, request, view=None):
        return request.method in SAFE_METHODS
    

class RegisterUserAPIView(CreateAPIView):

    serializer_class = RegisterUserSerializer
    queryset = User.objects.all()


class CheckAuthView(APIView):

    permission_classes = [IsAuthenticated]

    def get(self, request):
        return Response({'message': 'Authenticated'}, status=status.HTTP_200_OK)


class ListCreateProductView(ListCreateAPIView):

    permission_classes = [IsAdminUser|ReadOnly]
    serializer_class = ProductSerializer
    queryset = Product.objects.all()


class GetUpdateDeleteProductView(RetrieveUpdateDestroyAPIView):

    permission_classes = [IsAdminUser|ReadOnly]
    serializer_class = ProductSerializer
    queryset = Product.objects.all()


class ListCreateOrderItemView(ListCreateAPIView):

    permission_classes = [IsAuthenticated]
    serializer_class = OrderItemSerializer
    
    def get_queryset(self):
        if self.request.user.is_staff:
            return OrderItem.objects.all()
        return OrderItem.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        # Set the user to the authenticated user when creating a new order item
        serializer.save(user=self.request.user)


class GetUpdateDeleteOrderItemView(RetrieveUpdateDestroyAPIView):

    permission_classes = [IsAuthenticated]
    serializer_class = OrderItemSerializer
    
    def get_queryset(self):
        if self.request.user.is_staff:
            return OrderItem.objects.all()
        return OrderItem.objects.filter(user=self.request.user)


class ListCreateOrderView(ListCreateAPIView):

    permission_classes = [IsAuthenticated]
    serializer_class = OrderSerializer
    queryset = Order.objects.all()


class GetOrderView(RetrieveAPIView):

    permission_classes = [IsAuthenticated]
    serializer_class = OrderSerializer
    queryset = Order.objects.all()

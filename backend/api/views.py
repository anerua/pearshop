from django.contrib.auth.models import User
from rest_framework.generics import CreateAPIView, ListCreateAPIView, RetrieveUpdateDestroyAPIView, RetrieveAPIView
from rest_framework.permissions import BasePermission, IsAuthenticated, IsAdminUser, SAFE_METHODS

from .models import *
from .serializers import *


class ReadOnly(BasePermission):
    def has_permission(self, request, view=None):
        return request.method in SAFE_METHODS
    

class RegisterUserAPIView(CreateAPIView):

    serializer_class = RegisterUserSerializer
    queryset = User.objects.all()


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
    queryset = OrderItem.objects.all()


class GetOrderItemView(RetrieveAPIView):

    permission_classes = [IsAuthenticated]
    serializer_class = OrderItemSerializer
    queryset = OrderItem.objects.all()


class ListCreateOrderView(ListCreateAPIView):

    permission_classes = [IsAuthenticated]
    serializer_class = OrderSerializer
    queryset = Order.objects.all()


class GetOrderView(RetrieveAPIView):

    permission_classes = [IsAuthenticated]
    serializer_class = OrderSerializer
    queryset = Order.objects.all()

from django.contrib.auth.models import User
from rest_framework.generics import CreateAPIView, ListCreateAPIView, RetrieveUpdateDestroyAPIView, RetrieveAPIView, ListAPIView

from .models import *
from .serializers import *


class RegisterUserAPIView(CreateAPIView):

    serializer_class = RegisterUserSerializer
    queryset = User.objects.all()


class ListCreateProductView(ListCreateAPIView):

    serializer_class = ProductSerializer
    queryset = Product.objects.all()


class GetUpdateDeleteProductView(RetrieveUpdateDestroyAPIView):

    serializer_class = ProductSerializer
    queryset = Product.objects.all()


class ListCreateOrderItemView(ListCreateAPIView):

    serializer_class = OrderItemSerializer
    queryset = OrderItem.objects.all()


class GetOrderItemView(RetrieveAPIView):

    serializer_class = OrderItemSerializer
    queryset = OrderItem.objects.all()

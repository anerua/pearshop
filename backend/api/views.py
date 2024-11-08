from django.contrib.auth.models import User
from rest_framework.generics import CreateAPIView, ListCreateAPIView, RetrieveUpdateDestroyAPIView

from .models import Product
from .serializers import RegisterUserSerializer, ProductSerializer


class RegisterUserAPIView(CreateAPIView):

    serializer_class = RegisterUserSerializer
    queryset = User.objects.all()


class ListCreateProductView(ListCreateAPIView):

    serializer_class = ProductSerializer
    queryset = Product.objects.all()


class GetUpdateDeleteProductView(RetrieveUpdateDestroyAPIView):

    serializer_class = ProductSerializer
    queryset = Product.objects.all()

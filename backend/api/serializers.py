from django.contrib.auth.models import User
from rest_framework import serializers

from .models import *


class RegisterUserSerializer(serializers.ModelSerializer):

    password = serializers.CharField(max_length=255, write_only=True)

    class Meta:
        model = User
        fields = ["username", "password"]

    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        return user
    

class ProductSerializer(serializers.ModelSerializer):

    class Meta:
        model = Product
        fields = "__all__"


class OrderItemSerializer(serializers.ModelSerializer):

    class Meta:
        model = OrderItem
        fields = "__all__"


class OrderSerializer(serializers.ModelSerializer):

    class Meta:
        model = Order
        fields = "__all__"
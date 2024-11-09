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
    total_price = serializers.IntegerField(read_only=True)

    class Meta:
        model = OrderItem
        fields = "__all__"
        depth = 1

    def create(self, validated_data):
        product = validated_data.get('product')
        quantity = validated_data.get('quantity')
        
        # Calculate total price
        total_price = product.price * quantity
        validated_data['total_price'] = total_price
   
        return super().create(validated_data)

    def update(self, instance, validated_data):
        if 'quantity' in validated_data or 'product' in validated_data:
            product = validated_data.get('product', instance.product)
            quantity = validated_data.get('quantity', instance.quantity)
            validated_data['total_price'] = product.price * quantity
            
        return super().update(instance, validated_data)


class OrderSerializer(serializers.ModelSerializer):
    order_items = OrderItemSerializer(many=True, read_only=True)
    total_price = serializers.IntegerField(read_only=True)

    class Meta:
        model = Order
        fields = ["id", "user", "delivery_address", "order_items", "total_price", "created_at", "updated_at"]
        read_only_fields = ["total_price", "created_at", "updated_at"]
        depth = 2

    def create(self, validated_data):
        # Create the order first
        order = Order.objects.create(**validated_data)
        
        # Calculate total price from order items after they're added
        total_price = sum(item.total_price for item in order.order_items.all())
        order.total_price = total_price
        order.save()
        
        return order

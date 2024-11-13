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
    product_id = serializers.PrimaryKeyRelatedField(
        source='product',
        queryset=Product.objects.all(),
        write_only=True
    )

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
    total_price = serializers.IntegerField(read_only=True)
    order_item_ids = serializers.PrimaryKeyRelatedField(
        source='order_items',
        queryset=OrderItem.objects.all(),
        many=True,
        write_only=True
    )

    class Meta:
        model = Order
        fields = ["id", "user", "delivery_address", "order_items", "order_item_ids", "total_price", "created_at", "updated_at"]
        read_only_fields = ["total_price", "created_at", "updated_at"]
        depth = 2

    def create(self, validated_data):
        # Pop order_items from validated_data
        order_items = validated_data.pop('order_items', [])
        
        # Create the order
        order = Order.objects.create(**validated_data)
        
        # Add order items
        order.order_items.set(order_items)
        
        # Calculate total price from order items
        total_price = sum(item.total_price for item in order.order_items.all())
        order.total_price = total_price
        order.save()
        
        return order

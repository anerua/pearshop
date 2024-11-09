from django.db import models
from django.utils.translation import gettext_lazy as _
from django.contrib.auth.models import User


class TrackingModel(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True
        ordering = ("-updated_at",)


class Product(TrackingModel):
    
    name = models.CharField(_("Name of product"), max_length=255)
    price = models.IntegerField(_("Price of product in naira"))
    image = models.URLField(_("URL to product image"), blank=True)
    description = models.TextField(_("Description of product"), blank=True)


class OrderItem(TrackingModel):

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="user_orderitems")
    product = models.ForeignKey("Product", on_delete=models.CASCADE, related_name="product_orderitems")
    quantity = models.IntegerField(_("Quantity"))
    total_price = models.IntegerField(_("Total price of order item"))


class Order(TrackingModel):

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="user_orders")
    delivery_address = models.CharField(_("Delivery address"), max_length=255)
    order_items = models.ManyToManyField("OrderItem", related_name="orderitem_orders")
    total_price = models.IntegerField(_("Total price of order"), default=0)

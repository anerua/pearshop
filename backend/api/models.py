from django.db import models
from django.utils.translation import gettext_lazy as _


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


class OrderItem(TrackingModel):

    product = models.ForeignKey("Product", on_delete=models.CASCADE, related_name="product_orderitems")
    quantity = models.IntegerField(_("Quantity"))


class Order(TrackingModel):

    delivery_address = models.CharField(_("Delivery address"), max_length=255)
    order_items = models.ManyToManyField("OrderItem", related_name="orderitem_orders")
    total_price = models.IntegerField(_("Total price of order"))

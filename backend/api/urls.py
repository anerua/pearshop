from django.urls import path

from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

from .views import *

urlpatterns = [
    path('register/', RegisterUserAPIView.as_view(), name='register_user'),
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('check/', CheckAuthView.as_view(), name='check_auth'),

    path('product/<int:pk>/', GetUpdateDeleteProductView.as_view(), name='get_update_or_delete_product'),
    path('product/', ListCreateProductView.as_view(), name='list_or_create_product'),

    path('order-item/<int:pk>/', GetUpdateDeleteOrderItemView.as_view(), name='get_update_or_delete_order_item'),
    path('order-item/', ListCreateOrderItemView.as_view(), name='list_or_create_order_item'),

    path('order/<int:pk>/', GetOrderView.as_view(), name='get_order'),
    path('order/', ListCreateOrderView.as_view(), name='list_or_create_order'),
]

from django.urls import path

from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

from .views import RegisterUserAPIView, ListCreateProductView, GetUpdateDeleteProductView

urlpatterns = [
    path('register', RegisterUserAPIView.as_view(), name='register_user'),
    path('login', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

    path('product/<int:pk>', GetUpdateDeleteProductView.as_view(), name='get_update_or_delete_product'),
    path('products', ListCreateProductView.as_view(), name='list_products'),
    path('product', ListCreateProductView.as_view(), name='create_product'),
]

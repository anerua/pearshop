import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart_item.dart';
import 'auth_service.dart';

class CartService {
  static const String baseUrl = 'http://localhost:8000/api';
  final AuthService _authService = AuthService();

  Future<List<CartItem>> getCart() async {
    return await _authService.authenticatedRequest(() async {
      final token = await _authService.getAccessToken();
      final response = await http.get(
        Uri.parse('$baseUrl/order-item'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> cartJson = json.decode(response.body);
        return cartJson.map((json) => CartItem.fromJson(json)).toList();
      }
      if (response.statusCode == 401) {
        throw Exception('401 Authentication failed');
      }
      throw Exception('Failed to load cart');
    });
  }

  Future<void> addToCart(int productId, int quantity) async {
    return await _authService.authenticatedRequest(() async {
      final token = await _authService.getAccessToken();
      final response = await http.post(
        Uri.parse('$baseUrl/order-item'),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'product_id': productId.toString(),
          'quantity': quantity.toString()
        },
      );

      if (response.statusCode == 401) {
        throw Exception('401 Authentication failed');
      }
      if (response.statusCode != 201) {
        throw Exception('Failed to add to cart');
      }
    });
  }

  Future<void> removeFromCart(int productId) async {
    return await _authService.authenticatedRequest(() async {
      final token = await _authService.getAccessToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/order-item/$productId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 401) {
        throw Exception('401 Authentication failed');
      }
      if (response.statusCode != 204) {
        throw Exception('Failed to remove from cart');
      }
    });
  }

  Future<void> checkout() async {
    return await _authService.authenticatedRequest(() async {
      final token = await _authService.getAccessToken();
      final response = await http.post(
        Uri.parse('$baseUrl/cart/checkout/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 401) {
        throw Exception('401 Authentication failed');
      }
      if (response.statusCode != 200) {
        throw Exception('Failed to checkout');
      }
    });
  }
}

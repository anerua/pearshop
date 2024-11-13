import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/cart_item.dart';
import 'auth_service.dart';

class CartService {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api';
  final AuthService _authService = AuthService();

  Future<List<CartItem>> getCart() async {
    return await _authService.authenticatedRequest(() async {
      final token = await _authService.getAccessToken();
      final response = await http.get(
        Uri.parse('$baseUrl/order-item/'),
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
        Uri.parse('$baseUrl/order-item/'),
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
        Uri.parse('$baseUrl/order-item/$productId/'),
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

  Future<void> updateQuantity(int productId, int quantity) async {
    return await _authService.authenticatedRequest(() async {
      final token = await _authService.getAccessToken();
      final response = await http.patch(
        Uri.parse('$baseUrl/order-item/$productId/'),
        headers: {'Authorization': 'Bearer $token'},
        body: {'quantity': quantity.toString()},
      );

      if (response.statusCode == 401) {
        throw Exception('401 Authentication failed');
      }
      if (response.statusCode != 200) {
        throw Exception('Failed to update quantity');
      }
    });
  }

  Future<void> checkout(String address, List<int> cartItemIds) async {
    return await _authService.authenticatedRequest(() async {
      final token = await _authService.getAccessToken();
      final response = await http.post(
        Uri.parse('$baseUrl/order/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'delivery_address': address,
          'order_item_ids': cartItemIds,
        }),
      );

      if (response.statusCode == 401) {
        throw Exception('401 Authentication failed');
      }
      if (response.statusCode != 201) {
        throw Exception('Failed to checkout');
      }
    });
  }
}

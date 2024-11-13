import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import 'auth_service.dart';

class OrderService {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api';
  final AuthService _authService = AuthService();

  Future<List<Order>> getOrders() async {
    return await _authService.authenticatedRequest(() async {
      final token = await _authService.getAccessToken();
      final response = await http.get(
        Uri.parse('$baseUrl/order/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        final List<dynamic> ordersJson = decode;
        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders');
      }
    });
  }
}

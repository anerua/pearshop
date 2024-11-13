import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'auth_service.dart';

class ProductService {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api';
  final AuthService _authService = AuthService();

  Future<List<Product>> getProducts() async {
    return await _authService.authenticatedRequest(() async {
      final token = await _authService.getAccessToken();
      final response = await http.get(
        Uri.parse('$baseUrl/product/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(response.body);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      }
      if (response.statusCode == 401) {
        throw Exception('401 Authentication failed');
      }
      throw Exception('Failed to load products');
    });
  }

  Future<Product> getProductDetails(int id) async {
    return await _authService.authenticatedRequest(() async {
      final token = await _authService.getAccessToken();
      final response = await http.get(
        Uri.parse('$baseUrl/product/$id/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      }
      if (response.statusCode == 401) {
        throw Exception('401 Authentication failed');
      }
      throw Exception('Failed to load products');
    });
  }
}

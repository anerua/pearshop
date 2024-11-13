import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8000/api';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  Future<Map<String, String>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access'];
      final refreshToken = data['refresh'];
      await _saveTokens(accessToken, refreshToken);
      return {'access': accessToken, 'refresh': refreshToken};
    }
    throw Exception('Failed to login');
  }

  Future<String?> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token found');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/token/refresh/'),
        body: {
          'refresh': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final newAccessToken = json.decode(response.body)['access'];
        await _saveAccessToken(newAccessToken);
        return newAccessToken;
      } else {
        // If refresh token is invalid, clear tokens and throw exception
        await logout();
        throw Exception('Invalid refresh token');
      }
    } catch (e) {
      await logout();
      throw Exception('Failed to refresh token');
    }
  }

  Future<dynamic> authenticatedRequest(
      Future<dynamic> Function() request) async {
    try {
      return await request();
    } catch (e) {
      if (e.toString().contains('401')) {
        // Unauthorized error
        try {
          await refreshAccessToken();
          return await request(); // Retry the request with new token
        } catch (refreshError) {
          // If refresh fails, throw error to trigger logout
          throw Exception('401 Authentication failed');
        }
      }
      rethrow;
    }
  }

  Future<Map<String, String>> signup(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 201) {
      return await login(username, password);
    }
    throw Exception('Failed to signup');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessTokenKey);
    await prefs.remove(refreshTokenKey);
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessTokenKey, accessToken);
    await prefs.setString(refreshTokenKey, refreshToken);
  }

  Future<void> _saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessTokenKey, accessToken);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(refreshTokenKey);
  }
}

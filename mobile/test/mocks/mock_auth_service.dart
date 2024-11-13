import 'package:mockito/mockito.dart';
import 'package:mobile/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {
  String? _accessToken;
  String? _refreshToken;

  @override
  Future<Map<String, String>> login(String username, String password) async {
    if (username == 'testuser' && password == 'password123') {
      _accessToken = 'fake_access_token';
      _refreshToken = 'fake_refresh_token';
      return {
        'access': _accessToken!,
        'refresh': _refreshToken!,
      };
    }
    throw Exception('Failed to login');
  }

  @override
  Future<String?> getAccessToken() async {
    return _accessToken;
  }

  @override
  Future<String?> getRefreshToken() async {
    return _refreshToken;
  }

  @override
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
  }
}
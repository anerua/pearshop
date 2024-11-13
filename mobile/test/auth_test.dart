import 'package:flutter_test/flutter_test.dart';
import 'mocks/mock_auth_service.dart';

void main() {
  late MockAuthService authService;

  setUp(() {
    authService = MockAuthService();
  });

  group('Authentication Tests', () {
    test('Login with correct credentials should succeed', () async {
      final result = await authService.login('testuser', 'password123');
      
      expect(result['access'], isNotNull);
      expect(result['refresh'], isNotNull);
    });

    test('Login with incorrect credentials should fail', () async {
      expect(
        () => authService.login('wronguser', 'wrongpass'),
        throwsException,
      );
    });

    test('Logout should clear tokens', () async {
      await authService.login('testuser', 'password123');
      await authService.logout();

      final accessToken = await authService.getAccessToken();
      final refreshToken = await authService.getRefreshToken();

      expect(accessToken, isNull);
      expect(refreshToken, isNull);
    });
  });
}
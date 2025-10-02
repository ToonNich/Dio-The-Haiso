import 'package:dio/dio.dart';
import 'auth_model.dart';

class AuthRepository {
  final Dio _dio = Dio();
  String? _token;

  /// Mock login function ใช้ Dio + AuthModel
  Future<void> login(AuthModel auth) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final response = Response(
        requestOptions: RequestOptions(path: '/mock-login'),
        statusCode: 200,
        data:
            (auth.email == 'eve.holt@reqres.in' &&
                    auth.password == 'cityslicka')
                ? {'token': 'mock_token_12345'}
                : {'error': 'Invalid email or password'},
      );

      final data = response.data as Map<String, dynamic>?;

      if (response.statusCode == 200 && data?['token'] != null) {
        _token = data!['token'] as String;
      } else {
        throw Exception('Login failed: ${data?['error'] ?? 'Unknown error'}');
      }
    } on DioError catch (e) {
      throw Exception('DioError: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  bool get isLoggedIn => _token != null;
  String? get token => _token;
  void logout() => _token = null;
}

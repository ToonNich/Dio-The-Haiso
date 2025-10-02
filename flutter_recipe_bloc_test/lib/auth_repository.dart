import 'package:dio/dio.dart';
import 'auth_model.dart';

class AuthRepository {
  final Dio _dio = Dio();
  String? _token;

  AuthRepository() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.path == '/mock-login') {
            final data = options.data as Map<String, dynamic>?;

            if (data != null &&
                data['email'] == 'eve.holt@reqres.in' &&
                data['password'] == 'cityslicka') {
              // ส่ง response mock
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'token': 'mock_token_12345'},
                ),
              );
            } else {
              return handler.reject(
                DioError(
                  requestOptions: options,
                  response: Response(
                    requestOptions: options,
                    statusCode: 401,
                    data: {'error': 'Invalid email or password'},
                  ),
                ),
              );
            }
          }

          return handler.next(options);
        },
      ),
    );
  }

  Future<void> login(AuthModel auth) async {
    try {
      final response = await _dio.post('/mock-login', data: auth.toJson());

      _token = response.data['token'] as String?;
    } on DioError catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message);
    }
  }

  bool get isLoggedIn => _token != null;
  String? get token => _token;
  void logout() => _token = null;
}

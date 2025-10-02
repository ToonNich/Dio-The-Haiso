import 'package:dio/dio.dart';
import 'auth_model.dart';
import 'dart:developer';

class AuthRepository {
  final Dio _dio = Dio();
  String? _token;

 final List<Map<String, String>> _registeredUsers = [];
 
  AuthRepository() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.path == '/mock-login') {
            final data = options.data as Map<String, dynamic>?;

             if (data != null) {
              final user = _registeredUsers.firstWhere(
                (user) =>
                    user['email'] == data['email'] &&
                    user['password'] == data['password'],
                orElse: () => {},
              );

              if (user.isNotEmpty) {
                return handler.resolve(
                  Response(
                    requestOptions: options,
                    statusCode: 200,
                    data: {'token': 'mock_token_12345'},
                  ),
                );
              }
            }

            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 401,
                  data: {'error': 'Invalid email or password'},
                ),
              ),
            );
          }

           if (options.path == '/mock-register') {
            final data = options.data as Map<String, dynamic>?;
            if (data != null && data['email'] != null && data['password'] != null) {
              _registeredUsers.add({
                'email': data['email'],
                'password': data['password'],
              });

              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'token': 'mock_registered_token_${DateTime.now().millisecondsSinceEpoch}',
                  },
                ),
              );
            } else {
              // จำลอง response ล้มเหลว
              return handler.reject(
                DioException(
                  requestOptions: options,
                  response: Response(
                    requestOptions: options,
                    statusCode: 400,
                    data: {'error': 'Missing email or password'},
                  ),
                ),
              );
            }
          }
          return handler.next(options);
        },

        onResponse: (response, handler) {
          log('Dio Response: ${response.statusCode} | ${response.data}', name: 'Dio');
          return handler.next(response);
        },

        onError: (DioException err, handler) {
          log('Dio Error: ${err.response?.statusCode} | ${err.message}', name: 'Dio');
          return handler.next(err);
        },
      ),
    );
  }

  Future<void> login(AuthModel auth) async {
    try {
      final response = await _dio.post('/mock-login', data: auth.toJson());
      _token = response.data['token'] as String?;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message);
    }
  }

    Future<void> register(AuthModel auth) async {
    try {
      final response = await _dio.post('/mock-register', data: auth.toJson());

      _token = response.data['token'] as String?;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message);
    }
  }


  bool get isLoggedIn => _token != null;
  String? get token => _token;
  void logout() => _token = null;
}

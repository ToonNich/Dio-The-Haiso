import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_repository.dart';
import 'auth_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final String token;
  Authenticated(this.token);
}

class Unauthenticated extends AuthState {
  final String? message;
  Unauthenticated([this.message]);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<void> login(AuthModel auth) async {
    try {
      await authRepository.login(auth);
      if (authRepository.isLoggedIn) {
        emit(Authenticated(authRepository.token!));
      } else {
        emit(Unauthenticated("Invalid login"));
      }
    } catch (e) {
      emit(Unauthenticated(e.toString()));
    }
  }

  void logout() {
    authRepository.logout();
    emit(Unauthenticated());
  }

  bool get isLoggedIn => state is Authenticated;
}

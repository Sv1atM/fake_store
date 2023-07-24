import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fake_store/src/data/models/auth_credentials/auth_credentials.dart';
import 'package:fake_store/src/domain/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthInitial()) {
    checkAuthState();
  }

  final AuthRepository _authRepository;

  Future<void> checkAuthState() async {
    final authToken = await _authRepository.getAuthToken();

    if (authToken != null) {
      emit(const Authenticated());
    } else {
      emit(const Unauthenticated());
    }
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    emit(const AuthStateUpdating());

    try {
      final credentials = AuthCredentials(
        username: username,
        password: password,
      );
      final token = await _authRepository.userLogin(credentials);
      await _authRepository.saveAuthToken(token);

      emit(const Authenticated());
    } on DioException catch (e) {
      emit(AuthError(errorMessage: e.message ?? e.toString()));
    }
  }

  Future<void> logOut() async {
    emit(const AuthStateUpdating());

    try {
      await _authRepository.deleteAuthToken();

      emit(const Unauthenticated());
    } on DioException catch (e) {
      emit(AuthError(errorMessage: e.message ?? e.toString()));
    }
  }
}

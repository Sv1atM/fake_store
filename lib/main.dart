import 'package:dio/dio.dart';
import 'package:fake_store/src/app.dart';
import 'package:fake_store/src/config/environment.dart';
import 'package:fake_store/src/data/api/api.dart';
import 'package:fake_store/src/data/storages/storages.dart';
import 'package:fake_store/src/domain/controllers/auth_cubit/auth_cubit.dart';
import 'package:fake_store/src/domain/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
  );

  final client = Dio(BaseOptions(contentType: 'application/json'))
    ..interceptors.add(
      InterceptorsWrapper(
        onError: (err, handler) {
          final errorMessage = err.response?.data;

          if (errorMessage is String) {
            handler.next(err.copyWith(message: errorMessage));
          }
        },
      ),
    );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            authApi: AuthApi(client, baseUrl: Environment.apiUrl),
            tokenStorage: const TokenStorage(secureStorage),
          ),
        ),
        RepositoryProvider(
          create: (context) => ProductsRepository(
            productsApi: ProductsApi(client, baseUrl: Environment.apiUrl),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: const App(),
      ),
    ),
  );
}

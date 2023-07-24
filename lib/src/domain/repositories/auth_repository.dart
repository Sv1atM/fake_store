import 'package:fake_store/src/data/api/api.dart';
import 'package:fake_store/src/data/models/models.dart';
import 'package:fake_store/src/data/storages/storages.dart';

class AuthRepository {
  const AuthRepository({
    required AuthApi authApi,
    required TokenStorage tokenStorage,
  })  : _authApi = authApi,
        _tokenStorage = tokenStorage;

  final AuthApi _authApi;
  final TokenStorage _tokenStorage;

  Future<TokenData> userLogin(AuthCredentials credentials) =>
      _authApi.userLogin(credentials);

  Future<TokenData?> getAuthToken() => _tokenStorage.getAuthToken();

  Future<void> saveAuthToken(TokenData token) =>
      _tokenStorage.saveAuthToken(token);

  Future<void> deleteAuthToken() => _tokenStorage.deleteAuthToken();
}

import 'dart:convert';

import 'package:fake_store/src/data/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  const TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _authTokenKey = 'authToken';

  Future<void> saveAuthToken(TokenData token) async {
    final value = jsonEncode(token.toJson());

    await _storage.write(key: _authTokenKey, value: value);
  }

  Future<TokenData?> getAuthToken() async {
    final value = await _storage.read(key: _authTokenKey);

    if (value == null) return null;

    return TokenData.fromJson(jsonDecode(value) as Map<String, dynamic>);
  }

  Future<void> deleteAuthToken() => _storage.delete(key: _authTokenKey);
}

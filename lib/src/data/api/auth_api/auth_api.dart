import 'package:dio/dio.dart' hide Headers;
import 'package:fake_store/src/data/models/models.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi(parser: Parser.JsonSerializable)
abstract class AuthApi {
  factory AuthApi(
    Dio client, {
    String baseUrl,
  }) = _AuthApi;

  @POST('/auth/login')
  Future<TokenData> userLogin(
    @Body() AuthCredentials credentials,
  );
}

import 'package:dio/dio.dart' hide Headers;
import 'package:fake_store/src/data/models/models.dart';
import 'package:retrofit/retrofit.dart';

part 'products_api.g.dart';

@RestApi(parser: Parser.JsonSerializable)
abstract class ProductsApi {
  factory ProductsApi(
    Dio client, {
    String baseUrl,
  }) = _ProductsApi;

  @GET('/products')
  Future<List<Product>> getAllProducts();
}

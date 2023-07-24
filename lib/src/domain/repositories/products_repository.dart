import 'package:fake_store/src/data/api/api.dart';
import 'package:fake_store/src/data/models/models.dart';

class ProductsRepository {
  const ProductsRepository({
    required ProductsApi productsApi,
  }) : _productsApi = productsApi;

  final ProductsApi _productsApi;

  Future<List<Product>> fetchProducts() => _productsApi.getAllProducts();
}

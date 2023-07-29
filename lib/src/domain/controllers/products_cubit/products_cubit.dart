import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fake_store/src/data/models/models.dart';
import 'package:fake_store/src/domain/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({
    required ProductsRepository productsRepository,
  })  : _productsRepository = productsRepository,
        super(const ProductsInitial()) {
    refreshList();
  }

  final ProductsRepository _productsRepository;

  Future<void> refreshList() async {
    emit(ProductsFetching(products: state.products));

    try {
      final products = await _productsRepository.fetchProducts();

      emit(ProductsFetched(products: products));
    } on DioException catch (e) {
      emit(
        ProductsError(
          products: state.products,
          errorMessage: e.message ?? e.toString(),
        ),
      );
    }
  }

  void favoriteToggle(Product product) {
    final isFavorite = product.isFavorite;
    final updatedItem = product.copyWith(isFavorite: !isFavorite);

    emit(
      ProductLiked(
        products: [
          for (final item in state.products)
            if (item.id == product.id) updatedItem else item,
        ],
        product: updatedItem,
      ),
    );
  }
}

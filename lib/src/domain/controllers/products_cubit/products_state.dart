part of 'products_cubit.dart';

abstract class ProductsState extends Equatable {
  const ProductsState({
    required this.products,
  });

  final List<Product> products;
}

class ProductsInitial extends ProductsState {
  const ProductsInitial({
    super.products = const [],
  });

  @override
  List<Object?> get props => [];
}

class ProductsFetching extends ProductsState {
  const ProductsFetching({
    required super.products,
  });

  @override
  List<Object?> get props => [];
}

class ProductsFetched extends ProductsState {
  const ProductsFetched({
    required super.products,
  });

  @override
  List<Object?> get props => [products];
}

class ProductsError extends ProductsState {
  const ProductsError({
    required super.products,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

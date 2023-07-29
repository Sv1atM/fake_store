import 'dart:math';

import 'package:fake_store/src/config/constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String title,
    required double price,
    required String category,
    required String description,
    required String image,
    @Default(false) bool isFavorite,
  }) = _Product;

  const Product._();

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  // TODO(Sv1atM): use real product rate
  int get rate => Random().nextInt(kMaxRate + 1);
}

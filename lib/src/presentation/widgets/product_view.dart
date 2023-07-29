import 'package:fake_store/resources/resources.dart';
import 'package:fake_store/src/config/constants.dart';
import 'package:fake_store/src/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductView extends StatelessWidget {
  const ProductView(
    this.product, {
    this.onPressed,
    this.onLikePressed,
    super.key,
  });

  final Product product;
  final void Function(Product)? onPressed;
  final void Function(Product)? onLikePressed;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(11);

    return InkWell(
      onTap: (onPressed != null) ? () => onPressed!(product) : null,
      borderRadius: borderRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              offset: const Offset(0, 4.5288),
              blurRadius: 3.28338,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: const Offset(0, 12.52155),
              blurRadius: 9.07813,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: const Offset(0, 30.14707),
              blurRadius: 21.85663,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 100),
              blurRadius: 72.5,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Ink.image(
                          image: NetworkImage(product.image),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    _titleText(),
                    const SizedBox(height: 2),
                    _productRate(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _priceText(),
                  _favoriteButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleText() => ShaderMask(
        shaderCallback: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0),
          ],
          stops: const [0.64, 1],
        ).createShader,
        child: Text(
          product.title,
          style: const TextStyle(
            color: Color(0xFF313131),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.visible,
        ),
      );

  Widget _productRate() => Wrap(
        spacing: 2.35,
        children: List.generate(
          kMaxRate,
          (index) => SizedBox.square(
            dimension: 4.7143,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: (index < product.rate)
                    ? const Color(0xFFFFD646)
                    : const Color(0xFFE6E6E6),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );

  Widget _priceText() => Text(
        '\$ ${product.price.toStringAsFixed(2)}',
        style: const TextStyle(
          color: Color(0xFF313131),
          fontSize: 12,
        ),
      );

  Widget _favoriteButton() => IconButton(
        onPressed:
            (onLikePressed != null) ? () => onLikePressed!(product) : null,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: SvgPicture.asset(
            product.isFavorite ? SvgPictures.likeFilled : SvgPictures.like,
            key: ValueKey(product.isFavorite),
            colorFilter: ColorFilter.mode(
              product.isFavorite ? const Color(0xFFFF505A) : Colors.black,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
}

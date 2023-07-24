import 'dart:math';

import 'package:fake_store/resources/resources.dart';
import 'package:fake_store/src/data/models/models.dart';
import 'package:fake_store/src/domain/controllers/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchFieldController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _random = Random();

  late ThemeData _theme;
  late Orientation _orientation;
  late EdgeInsets _viewPadding;

  Future<void> _onLogOutPressed() => context.read<AuthCubit>().logOut();

  Future<void> _onProductsListRefresh() =>
      context.read<ProductsCubit>().refreshList();

  // TODO(Sv1atM): add search action
  void _onSearchButtonPressed() => throw UnimplementedError();

  void _onMenuButtonPressed() => _scaffoldKey.currentState?.openDrawer();

  String _convertPrice(double value) => '\$ ${value.toStringAsFixed(2)}';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
    _orientation = MediaQuery.orientationOf(context);
    _viewPadding = MediaQuery.viewPaddingOf(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _drawer(),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _menuButton(),
                ),
                Expanded(child: _searchField()),
                const SizedBox(width: 15),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned.fill(child: _productsList()),
                  Positioned(
                    bottom: _viewPadding.bottom + 2,
                    child: _cartButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }

  Widget _menuButton() => IconButton(
        onPressed: _onMenuButtonPressed,
        icon: SvgPicture.asset(SvgPictures.menu),
      );

  Widget _drawer() => Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const DrawerHeader(child: Text('Drawer')),
              TextButton(
                onPressed: _onLogOutPressed,
                child: const Text('Log Out'),
              ),
            ],
          ),
        ),
      );

  Widget _searchField() => TextField(
        controller: _searchFieldController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFEEEEEE),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(21.391),
          ),
          suffixIcon: IconButton(
            onPressed: _onSearchButtonPressed,
            icon: const Icon(
              CupertinoIcons.search,
              color: Color(0xFFA0A0A0),
            ),
          ),
        ),
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      );

  Widget _titleText() => const Text(
        'Special offers',
        style: TextStyle(
          color: Color(0xFF313131),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );

  Widget _subtitleText() => const Text(
        'The best prices',
        style: TextStyle(
          color: Color(0xFF313131),
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
      );

  Widget _productsList() => RefreshIndicator.adaptive(
        onRefresh: _onProductsListRefresh,
        child: BlocSelector<ProductsCubit, ProductsState, List<Product>>(
          selector: (state) => state.products,
          builder: (context, items) => CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(26, 20, 26, 15),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _titleText(),
                    _subtitleText(),
                  ]),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(26, 0, 26, _viewPadding.bottom),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _productView(items[index]),
                    childCount: items.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        (_orientation == Orientation.portrait) ? 2 : 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 9,
                    childAspectRatio: 157 / 181,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _productView(Product product) {
    const maxRate = 5;
    // TODO(Sv1atM): use real product rate
    final rate = _random.nextInt(maxRate + 1);

    // TODO(Sv1atM): make _productView tappable
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Image.network(product.image),
            ),
          ),
          const SizedBox(height: 2),
          ShaderMask(
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
          ),
          const SizedBox(height: 2),
          Wrap(
            spacing: 2.35,
            children: List.generate(
              maxRate,
              (index) => SizedBox.square(
                dimension: 4.7143,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: (index < rate)
                        ? const Color(0xFFFFD646)
                        : const Color(0xFFE6E6E6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _convertPrice(product.price),
                style: const TextStyle(
                  color: Color(0xFF313131),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TODO(Sv1atM): make _cartButton tappable
  Widget _cartButton() => Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: _theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(5.29),
        ),
        child: SvgPicture.asset(
          SvgPictures.sacola,
          width: 25.58,
          height: 22.59,
          fit: BoxFit.scaleDown,
          colorFilter: ColorFilter.mode(
            _theme.colorScheme.onPrimary,
            BlendMode.srcIn,
          ),
        ),
      );
}

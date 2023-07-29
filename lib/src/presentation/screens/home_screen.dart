import 'package:fake_store/resources/resources.dart';
import 'package:fake_store/src/data/models/models.dart';
import 'package:fake_store/src/domain/controllers/controllers.dart';
import 'package:fake_store/src/presentation/widgets/widgets.dart';
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

  late ThemeData _theme;
  late EdgeInsets _viewPadding;

  Future<void> _onLogOutPressed() => context.read<AuthCubit>().logOut();

  Future<void> _onProductsListRefresh() =>
      context.read<ProductsCubit>().refreshList();

  void _onMenuButtonPressed() => _scaffoldKey.currentState?.openDrawer();

  // TODO(Sv1atM): add search action
  void _onSearchButtonPressed() => throw UnimplementedError();

  // TODO(Sv1atM): add product pressed action
  void _onProductPressed(Product product) => throw UnimplementedError();

  void _onLikePressed(Product product) =>
      context.read<ProductsCubit>().favoriteToggle(product);

  // TODO(Sv1atM): add cart pressed action
  void _onCartPressed() => throw UnimplementedError();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
    _viewPadding = MediaQuery.viewPaddingOf(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductsError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          flexibleSpace: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 15),
            bottom: false,
            child: Center(
              child: Row(
                children: [
                  _menuButton(),
                  const SizedBox(width: 15),
                  Expanded(child: _searchField()),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          bottom: false,
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
        drawer: _drawer(),
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
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 12,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(21.391),
          ),
          suffixIcon: IconButton(
            onPressed: _onSearchButtonPressed,
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              SvgPictures.search,
              colorFilter: const ColorFilter.mode(
                Color(0xFFA0A0A0),
                BlendMode.srcIn,
              ),
            ),
            iconSize: 17.83,
          ),
          suffixIconConstraints: const BoxConstraints(maxHeight: 34),
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
                padding: EdgeInsets.fromLTRB(
                  26,
                  0,
                  26,
                  _viewPadding.bottom + 68,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductView(
                      items[index],
                      onPressed: _onProductPressed,
                      onLikePressed: _onLikePressed,
                    ),
                    childCount: items.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
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

  Widget _cartButton() => ElevatedButton(
        onPressed: _onCartPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _theme.colorScheme.primary,
          foregroundColor: _theme.colorScheme.onPrimary,
          fixedSize: const Size.square(55),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.29),
          ),
          elevation: 0,
        ),
        child: SvgPicture.asset(SvgPictures.cart),
      );
}

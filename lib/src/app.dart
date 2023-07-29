import 'package:fake_store/resources/resources.dart';
import 'package:fake_store/src/config/routes.dart';
import 'package:fake_store/src/domain/controllers/controllers.dart';
import 'package:fake_store/src/domain/repositories/products_repository.dart';
import 'package:fake_store/src/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  ScaffoldMessengerState get _messenger => _messengerKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          _navigator.pushNamedAndRemoveUntil(
            Routes.login,
            (route) => false,
          );
        } else if (state is Authenticated) {
          _navigator.pushNamedAndRemoveUntil(
            Routes.home,
            (route) => false,
          );
        } else if (state is AuthError) {
          _messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
        }
      },
      child: MaterialApp(
        title: 'eComerce',
        navigatorKey: _navigatorKey,
        scaffoldMessengerKey: _messengerKey,
        initialRoute: Routes.root,
        routes: {
          Routes.root: (context) => const SplashScreen(),
          Routes.login: (context) => const LoginScreen(),
          Routes.home: (context) => BlocProvider(
                create: (context) => ProductsCubit(
                  productsRepository: context.read<ProductsRepository>(),
                ),
                child: const HomeScreen(),
              ),
        },
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF158A8A),
            primary: const Color(0xFF158A8A),
            onPrimary: const Color(0xFFF3F3F3),
          ),
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          inputDecorationTheme: const InputDecorationTheme(
            // TODO(Sv1atM): use CustomPainter to draw custom border style
            border: UnderlineInputBorder(),
            hintStyle: TextStyle(
              color: Color(0xFF9D9D9D),
              fontSize: 14,
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          useMaterial3: true,
          fontFamily: FontFamily.poppins,
        ),
      ),
    );
  }
}

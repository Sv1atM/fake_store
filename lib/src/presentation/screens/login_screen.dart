import 'package:fake_store/resources/resources.dart';
import 'package:fake_store/src/domain/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  var _obscurePassword = true;

  late ThemeData _theme;

  Future<void> _onLogInPressed() => context.read<AuthCubit>().logIn(
        username: _usernameFieldController.text.trim(),
        password: _passwordFieldController.text,
      );

  // TODO(Sv1atM): add forgot password action
  void _onForgotPassword() => throw UnimplementedError();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.all(20);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: padding,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - padding.vertical,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _titleText(),
                    const SizedBox(height: 80),
                    _usernameField(),
                    const SizedBox(height: 24),
                    _passwordField(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _forgotPasswordButton(),
                    ),
                    const SizedBox(height: 20),
                    _logInButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }

  Widget _titleText() => const Text(
        'eComerce',
        style: TextStyle(
          fontSize: 46.48,
          fontWeight: FontWeight.w400,
          fontFamily: FontFamily.prata,
        ),
        textAlign: TextAlign.center,
      );

  Widget _usernameField() => TextField(
        controller: _usernameFieldController,
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          hintText: 'User name',
        ),
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      );

  Widget _passwordField() => StatefulBuilder(
        builder: (context, setState) => TextField(
          controller: _passwordFieldController,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: 'Password',
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                _obscurePassword = !_obscurePassword;
              }),
              // TODO(Sv1atM): use proper icon
              icon: const Icon(Icons.remove_red_eye_outlined),
            ),
          ),
          obscureText: _obscurePassword,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
        ),
      );

  Widget _forgotPasswordButton() => TextButton(
        onPressed: _onForgotPassword,
        child: Text(
          'Forgot password',
          style: TextStyle(
            color: _theme.colorScheme.primary,
            fontSize: 12,
          ),
        ),
      );

  Widget _logInButton() => ElevatedButton(
        onPressed: _onLogInPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _theme.colorScheme.primary,
          foregroundColor: _theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.138),
          ),
          elevation: 0,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(height: 43.32),
          child: const Center(child: Text('Log In')),
        ),
      );
}

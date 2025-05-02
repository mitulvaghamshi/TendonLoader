import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/models/user.dart';
import 'package:tendon_loader/states/app_scope.dart';
import 'package:tendon_loader/ui/widgets/app_logo.dart';
import 'package:tendon_loader/ui/widgets/button_factory.dart';
import 'package:tendon_loader/ui/widgets/input_factory.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.child});

  final Widget child;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  late final state = AppScope.of(context);

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kDebugMode) {
      _usernameCtrl.text = 'user@email.com';
      _passwordCtrl.text = '123456';
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    setState(() => _isLoading = true);
    try {
      final user = User.from(
        username: _usernameCtrl.text,
        password: _passwordCtrl.text,
      );
      await state.authenticate(user);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && state.authUser.token != null) {
      return widget.child;
    }
    return Form(
      child: Column(
        children: [
          const AppLogo(radius: 140, padding: EdgeInsets.all(16)),
          InputFactory.form(
            label: 'Enter username',
            controller: _usernameCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          InputFactory.form(
            label: 'Enter password',
            controller: _passwordCtrl,
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 16),
          AnimatedCrossFade(
            crossFadeState:
                _isLoading
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 500),
            firstChild: const ButtonFactory.loading(),
            secondChild: ButtonFactory.tile(
              onTap: _authenticate,
              color: Theme.of(context).primaryColor,
              child: const Text('Login', style: Styles.whiteBold),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {},
            child: const Text("Don't have an account?"),
          ),
        ],
      ),
    );
  }
}

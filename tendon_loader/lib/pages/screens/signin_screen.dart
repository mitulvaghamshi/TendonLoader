import 'dart:async';

import 'package:api_server/api_server.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/api/network_status.dart';
import 'package:tendon_loader/pages/widgets/app_logo.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';
import 'package:tendon_loader/pages/widgets/input_factory.dart';
import 'package:tendon_loader/state/app_scope.dart';
import 'package:tendon_loader/state/app_state.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class SignInScreen extends StatefulWidget {
  const SignInScreen({required this.child, super.key});

  final Widget child;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final state = context.read<AppState>();

  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    /// Start [NetworkStatus] listener.
    NetworkStatus();
    super.initState();
  }

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
      final user = const User.empty().copyWith(
        username: _usernameCtrl.text,
        password: _passwordCtrl.text,
      );
      final result = await state.authenticate(user);
      if (mounted && result.isNotEmpty) {
        final snakbar = SnackBar(content: Text(result));
        ScaffoldMessenger.of(context).showSnackBar(snakbar);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (state.isAuthenticated) {
      return widget.child;
    }
    return Form(
      child: Column(
        children: [
          AppLogo(
            radius: MediaQuery.sizeOf(context).width * 0.4,
            padding: const .all(16),
          ),
          InputFactory.form(
            label: 'Enter username',
            controller: _usernameCtrl,
            keyboardType: .emailAddress,
          ),
          InputFactory.form(
            label: 'Enter password',
            controller: _passwordCtrl,
            keyboardType: .visiblePassword,
          ),
          const SizedBox(height: 16),
          AnimatedCrossFade(
            crossFadeState: _isLoading ? .showFirst : .showSecond,
            duration: const .new(milliseconds: 500),
            firstChild: const ButtonFactory.loading(),
            secondChild: ButtonFactory.tile(
              onTap: _authenticate,
              color: Theme.of(context).primaryColor,
              child: const Text('Login', style: Styles.whiteBold),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Not implemented yet')),
            ),
            child: const Text("Don't have an account?"),
          ),
        ],
      ),
    );
  }
}

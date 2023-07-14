import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/states/app_scope.dart';
import 'package:tendon_loader/widgets/image_widget.dart';
import 'package:tendon_loader/widgets/input_widget.dart';
import 'package:tendon_loader/widgets/raw_button.dart';

@immutable
final class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key, required this.builder});

  final ValueGetter builder;

  @override
  State<SignInWidget> createState() => SignInWidgetState();
}

final class SignInWidgetState extends State<SignInWidget> {
  late final api = AppScope.of(context).service;
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void didChangeDependencies() {
    if (kDebugMode) {
      _usernameCtrl.text = 'user@email.com';
      _passwordCtrl.text = '123456';
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    setState(() => _loading = true);
    await api.authenticate(
      username: _usernameCtrl.text,
      password: _passwordCtrl.text,
    );
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = api.user;
    if (!_loading && user != null) return widget.builder();
    return Form(
      child: Column(children: [
        const Hero(tag: 'hero-app-logo', child: AppLogo.square()),
        InputWidget.validated(
          label: 'Enter username',
          controller: _usernameCtrl,
          keyboardType: TextInputType.emailAddress,
        ),
        InputWidget.validated(
          label: 'Enter password',
          controller: _passwordCtrl,
          keyboardType: TextInputType.visiblePassword,
        ),
        const SizedBox(height: 16),
        AnimatedCrossFade(
          crossFadeState:
              _loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 500),
          firstChild: RawButton.tile(
            onTap: _authenticate,
            color: Colors.orange,
            child: const Text('Login', style: Styles.boldWhite),
          ),
          secondChild: const RawButton.tile(
            color: Colors.indigo,
            leading: CupertinoActivityIndicator(),
            child: Text('Please wait...', style: Styles.boldWhite),
          ),
        ),
      ]),
    );
  }
}

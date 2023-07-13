import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/widgets/app_logo.dart';
import 'package:tendon_loader/common/widgets/input_widget.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/network/app_scope.dart';

@immutable
final class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key, required this.builder});

  final ValueGetter builder;

  @override
  State<SignInWidget> createState() => SignInWidgetState();
}

final class SignInWidgetState extends State<SignInWidget> {
  late final api = AppScope.of(context).api;
  final _userNameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _userNameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    setState(() => _loading = true);
    await api.authenticate(
      username: _userNameCtrl.text,
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
        const Hero(tag: 'hero-app-logo', child: AppLogo.sized()),
        InputWidget(
          label: 'Enter username',
          controller: _userNameCtrl,
          keyboardType: TextInputType.emailAddress,
        ),
        InputWidget(
          label: 'Enter password',
          controller: _passwordCtrl,
          keyboardType: TextInputType.visiblePassword,
        ),
        const SizedBox(height: 16),
        AnimatedCrossFade(
          crossFadeState:
              _loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 500),
          firstChild: RawButton.extended(
            onTap: _authenticate,
            color: Colors.orange,
            child: const Text('Login', style: Styles.boldWhite),
          ),
          secondChild: RawButton.icon(
            color: Colors.indigo,
            left: const CupertinoActivityIndicator(),
            right: const Text('Plaase wait...'),
          ),
        ),
      ]),
    );
  }
}

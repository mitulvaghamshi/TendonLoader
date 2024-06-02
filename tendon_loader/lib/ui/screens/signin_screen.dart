import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/ui/widgets/app_logo.dart';
import 'package:tendon_loader/ui/widgets/input_field.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/states/app_scope.dart';

@immutable
final class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

final class SignInScreenState extends State<SignInScreen> {
  late final state = AppScope.of(context);
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

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
    setState(() => _loading = true);
    await state.authenticate(
      username: _usernameCtrl.text,
      password: _passwordCtrl.text,
    );
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loading && state.user != null) return widget.builder(context);
    return Form(
      child: Column(children: [
        const Hero(tag: 'hero-app-logo', child: AppLogo.square()),
        InputField.form(
          label: 'Enter username',
          controller: _usernameCtrl,
          keyboardType: TextInputType.emailAddress,
        ),
        InputField.form(
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

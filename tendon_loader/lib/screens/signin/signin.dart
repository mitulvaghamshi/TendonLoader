import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/widgets/app_logo.dart';
import 'package:tendon_loader/common/widgets/input_widget.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/network/app_scope.dart';
import 'package:tendon_loader/network/user.dart';

@immutable
final class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.builder});

  final Widget Function(BuildContext context, User user) builder;

  @override
  State<SignIn> createState() => SignInState();
}

final class SignInState extends State<SignIn> {
  final _userNameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final api = AppScope.of(context).api;
    final user = api.user;
    if (user != null) return widget.builder(context, user);
    return Form(
      child: Column(children: [
        const AppLogo.padded(),
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
        RawButton.extended(
          onTap: () async => api.authenticate(
            username: _userNameCtrl.text,
            password: _passwordCtrl.text,
          ),
          color: Colors.orange,
          child: const Text('Login', style: Styles.boldWhite),
        ),
      ]),
    );
  }
}

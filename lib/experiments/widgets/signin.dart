import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:tendon_loader/experimentwidgets/list_widget.dart';

@immutable
class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) return const ListWidget();
        return const SignInScreen(
          email: kDebugMode ? 'mitul@gmail.com' : null,
          providerConfigs: [EmailProviderConfiguration()],
        );
      },
    );
  }
}

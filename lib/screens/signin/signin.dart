import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/common/widgets/image_widget.dart';
import 'package:tendon_loader/common/widgets/loading_widget.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';

@immutable
class SignIn extends StatelessWidget {
  const SignIn({super.key, required this.builder});

  final Widget Function(BuildContext, User) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final User? user = snapshot.data;
          if (user == null) throw 'Unable to identify user!';
          final String? email = user.email;
          if (email == null) throw 'Cannot find valid user id!';
          return FutureBuilder<void>(
            future: AppState.of(context).initWith(email),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return builder(context, user);
              }
              return const Center(child: LoadingWidget());
            },
          );
        }
        return SignInScreen(
          headerMaxExtent: 280,
          showAuthActionSwitch: true,
          sideBuilder: (_, __) => const ImageWidget(),
          headerBuilder: (_, __, ___) => const ImageWidget(),
          subtitleBuilder: (_, __) => const Text('Welcome to Tendon Loader'),
          footerBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'By signing in, you agree to our terms and conditions.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}

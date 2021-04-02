import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/login/signin.dart';
import 'package:tendon_loader/utils/authentication.dart';

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Authentication.init(),
      builder: (_, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) return const SignIn();
        return Container(alignment: Alignment.center, color: Theme.of(context).primaryColor, child: const CircularProgressIndicator());
      },
    );
  }
}

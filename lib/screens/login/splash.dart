import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/utils/cloud/app_auth.dart';

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: AppAuth.init(),
      builder: (_, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) return const Login();
        return Container(alignment: Alignment.center, color: Theme.of(context).primaryColor, child: const CircularProgressIndicator());
      },
    );
  }
}

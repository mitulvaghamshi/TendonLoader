import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/login/initializer.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/login/login.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  static const String route = Navigator.defaultRouteName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: init(context),
      builder: (_, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) return const Login();
        return Container(
          alignment: Alignment.center,
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(30),
          child: const AppLogo(radius: 200),
        );
      },
    );
  }
}

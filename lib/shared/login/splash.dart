import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/custom/custom_image.dart';
import 'package:tendon_loader/shared/login/login.dart';
import 'package:tendon_loader/shared/setup.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  static const String route = Navigator.defaultRouteName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Setup.start(),
      builder: (_, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) return const Login();
        return Container(color: Theme.of(context).primaryColor, child: const CustomImage());
      },
    );
  }
}

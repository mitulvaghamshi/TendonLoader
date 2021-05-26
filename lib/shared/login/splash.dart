import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/app_auth.dart';
import 'package:tendon_loader/shared/custom/custom_image.dart';
import 'package:tendon_loader/shared/login/login.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: AppAuth.init(),
      builder: (_, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) return const Login();
        return Container(color: Theme.of(context).primaryColor, child: const CustomImage());
      },
    );
  }
}

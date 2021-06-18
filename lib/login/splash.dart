import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/login/app_auth.dart';
import 'package:tendon_loader/login/login.dart';
 
final Completer<void> _completer = Completer<void>();

Future<void> _init() async {
  if (!_completer.isCompleted) {
    await initApp();
    await Hive.initFlutter();
    await Hive.openBox<Map<dynamic, dynamic>>(keyLoginBox);
    await Hive.openBox<Map<dynamic, dynamic>>(keyExportBox); // app
    await Hive.openBox<Map<dynamic, dynamic>>(keyAppSettingsBox); // app
    Future<void>.delayed(const Duration(seconds: 2), () => _completer.complete());
  }
  return _completer.future;
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  static const String route = Navigator.defaultRouteName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _init(),
      builder: (_, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) return const Login();
        return Container(color: Theme.of(context).primaryColor, child: const AppLogo());
      },
    );
  }
}

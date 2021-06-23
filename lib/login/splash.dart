import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/handler/app_auth.dart';
import 'package:tendon_loader/login/login.dart';

final Completer<void> _completer = Completer<void>();

Future<void> _init(BuildContext context) async {
  if (!_completer.isCompleted) {
    await initApp();
    await Hive.initFlutter();
    await Hive.openBox<Map<dynamic, dynamic>>(keyLoginBox);
    await Hive.openBox<Map<dynamic, dynamic>>(keyExportBox); // app
    await Hive.openBox<Map<dynamic, dynamic>>(keyAppSettingsBox); // app
    await AppStateScope.of(context).initAppSettings();
    _completer.complete();
  }
  return _completer.future;
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  static const String route = Navigator.defaultRouteName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _init(context),
      builder: (_, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) return const Login();
        return Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(30),
          child: const AppLogo(radius: 200),
        );
      },
    );
  }
}

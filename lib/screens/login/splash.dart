import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/handlers/auth_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/timestamp.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/keys.dart';

late final Box<Export> boxExport;
late final Box<UserState> boxUserState;
late final Box<SettingsState> boxSettingsState;

Completer<void>? _completer;

Future<void> _init(BuildContext context) async {
  try {
    if (_completer == null) {
      _completer = Completer<void>();
      await initFirebase();
      await Hive.initFlutter();
      Hive.registerAdapter(UserStateAdapter());
      if (!kIsWeb) {
        Hive.registerAdapter(ExportAdapter());
        Hive.registerAdapter(ChartDataAdapter());
        Hive.registerAdapter(TimestampAdapter());
        Hive.registerAdapter(PrescriptionAdapter());
        Hive.registerAdapter(SettingsStateAdapter());
        boxExport = await Hive.openBox<Export>(keyExportBox);
        boxSettingsState = await Hive.openBox<SettingsState>(keySettingsStateBox);
        await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
      }
      boxUserState = await Hive.openBox<UserState>(keyUserStateBox);
      context.model.userState = boxUserState.get(keyUserStateBoxItem, defaultValue: UserState());
    }
  } finally {
    await Future<void>.delayed(const Duration(seconds: 1)).then(_completer!.complete);
  }
  return _completer!.future;
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
        return const CustomImage();
      },
    );
  }
}

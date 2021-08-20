import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/timestamp.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/screens/login.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/extension.dart';

Completer<bool>? _completer;

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  static const String route = Navigator.defaultRouteName;

  Future<bool> _init(BuildContext context) async {
    if (_completer == null) {
      _completer = Completer<bool>();
      await Hive.initFlutter();
      await Firebase.initializeApp();
      Hive.registerAdapter(ExportAdapter());
      Hive.registerAdapter(UserStateAdapter());
      Hive.registerAdapter(ChartDataAdapter());
      Hive.registerAdapter(TimestampAdapter());
      Hive.registerAdapter(PrescriptionAdapter());
      Hive.registerAdapter(SettingsStateAdapter());
      context.data.boxExport = await Hive.openBox<Export>(keyExportBox);
      context.data.boxDarkMode = await Hive.openBox<bool>(keyDarkModeBox);
      context.data.boxUserState =
          await Hive.openBox<UserState>(keyUserStateBox);
      context.data.boxSettingsState =
          await Hive.openBox<SettingsState>(keySettingsStateBox);
      if (!kIsWeb) {
        await SystemChrome.setPreferredOrientations(
          <DeviceOrientation>[DeviceOrientation.portraitUp],
        );
      }
      // await useEmulator();
      await Future<void>.delayed(const Duration(seconds: 2), () {
        _completer!.complete(true);
      });
    }
    return _completer!.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _init(context),
      initialData: false,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data ?? false) {
          return const Login();
        }
        return const CustomImage();
      },
    );
  }
}

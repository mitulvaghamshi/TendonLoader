import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/timestamp.g.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/utils/app_auth.dart';
import 'package:tendon_loader/utils/extension.dart';

late final Box<Export> boxExport;
late final Box<UserState> boxUserState;
late final Box<SettingsState> boxSettingsState;

Completer<void>? _completer;

Future<void> init(BuildContext context) async {
  try {
    if (_completer == null) {
      _completer = Completer<void>();
      await initFirebase();
      await Hive.initFlutter();
      Hive.registerAdapter(UserStateAdapter());
      Hive.registerAdapter(SettingsStateAdapter());
      if (!kIsWeb) {
        Hive.registerAdapter(ExportAdapter());
        Hive.registerAdapter(ChartDataAdapter());
        Hive.registerAdapter(TimestampAdapter());
        Hive.registerAdapter(PrescriptionAdapter());
        boxExport = await Hive.openBox<Export>(keyExportBox);
        boxSettingsState = await Hive.openBox<SettingsState>(keySettingsStateBox);
      }
      boxUserState = await Hive.openBox<UserState>(keyUserStateBox);
      context.model.userState = boxUserState.get(keyUserStateBoxItem, defaultValue: UserState());
      await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
    }
  } finally {
    await Future<void>.delayed(const Duration(seconds: 1)).then(_completer!.complete);
  }
  return _completer!.future;
}

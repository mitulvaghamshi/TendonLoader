import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/login/app_auth.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/timestamp_adapter.dart';

late final Box<Export> boxExport;
late final Box<UserState> boxUserState;
late final Box<SettingsState> boxSettingsState;

Future<void> initBox() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserStateAdapter());
  Hive.registerAdapter(SettingsStateAdapter());
  if (!kIsWeb) {
    Hive.registerAdapter(ExportAdapter());
    Hive.registerAdapter(ChartDataAdapter());
    Hive.registerAdapter(TimestampAdapter());
    Hive.registerAdapter(PrescriptionAdapter());
    boxExport = await Hive.openBox<Export>(keyExportBox);
    boxSettingsState = await Hive.openBox<SettingsState>('box_settings_state');
  }
  boxUserState = await Hive.openBox<UserState>('box_user_state');
}

Future<void> initAppState(BuildContext context) async {
  AppStateScope.of(context).userState = boxUserState.get('box_user_state_item', defaultValue: UserState());
}

final Completer<void> _completer = Completer<void>();

Future<void> init(BuildContext context) async {
  if (_completer.isCompleted) return;
  await initApp();
  await initBox();
  await initAppState(context);
  _completer.complete();
  return _completer.future;
}

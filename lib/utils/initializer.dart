import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

late final Box<Export> _boxExport;
late final Box<UserState> _boxUserState;
late final Box<SettingsState> _boxSettingsState;

Box<Export> get boxExport => _boxExport;
Box<UserState> get boxUserState => _boxUserState;
Box<SettingsState> get boxSettingsState => _boxSettingsState;

Completer<void>? _completer;

Future<void> init(BuildContext context) async {
  if (_completer == null) {
    _completer = Completer<void>();
    await initFirebase();
    Hive..registerAdapter(UserStateAdapter())..registerAdapter(SettingsStateAdapter());
    if (!kIsWeb) {
      await Hive.initFlutter();
      Hive
        ..registerAdapter(ExportAdapter())
        ..registerAdapter(ChartDataAdapter())
        ..registerAdapter(TimestampAdapter())
        ..registerAdapter(PrescriptionAdapter());
      _boxExport = await Hive.openBox<Export>(keyExportBox);
      _boxSettingsState = await Hive.openBox<SettingsState>(keySettingsStateBox);
    }
    _boxUserState = await Hive.openBox<UserState>(keyUserStateBox);
    context.model.userState = _boxUserState.get(keyUserStateBoxItem, defaultValue: UserState());
    _completer!.complete();
  }
  return _completer!.future;
}

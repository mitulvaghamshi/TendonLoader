import 'dart:collection';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/user_state.dart';

class AppState {
  Box<bool>? boxDarkMode;
  Box<Export>? boxExport;
  Box<UserState>? boxUserState;
  Box<SettingsState>? boxSettingsState;

  Patient? currentUser;
  UserState? userState;
  SettingsState? settingsState;

  final Map<int, Patient> users = HashMap<int, Patient>();
}

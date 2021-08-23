import 'dart:collection';

import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/user_state.dart';

class AppState {
  Patient? currentUser;
  UserState? userState;
  SettingsState? settingsState;

  final Map<int, Patient> users = HashMap<int, Patient>();
}

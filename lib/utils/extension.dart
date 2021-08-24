import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/utils/common.dart';

extension ExString on String {
  DataCell get toCell {
    return DataCell(Text(this, style: const TextStyle(fontSize: 16)));
  }
}

extension ExContext on BuildContext {
  Patient get patient => data.currentUser!;
  set patient(Patient? patient) => data.currentUser = patient;

  UserState get userState => data.userState!;
  set userState(UserState? userState) => data.userState = userState;

  SettingsState get settingsState => data.settingsState!;
  set settingsState(SettingsState? settings) => data.settingsState = settings;

  AppState get data {
    return dependOnInheritedWidgetOfExactType<AppStateScope>()!.data;
  }

  void showSnackBar(Widget content) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: content));
  }

  void pop<T extends Object?>([T? result]) => Navigator.pop<T>(this, result);

  Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) {
    return Navigator.push<T>(this, buildRoute<T>(routeName));
  }

  Future<T?> replace<T extends Object?>(String routeName) {
    return Navigator.pushReplacement<T, T>(this, buildRoute<T>(routeName));
  }
}

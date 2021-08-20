import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/app_state/app_state.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/modal/export.dart';
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
  UserState get userState => data.userState!;
  SettingsState get settingsState => data.settingsState!;

  Box<Export> get boxExport => data.boxExport!;
  Box<bool> get boxDarkMode => data.boxDarkMode!;
  Box<UserState> get boxUserState => data.boxUserState!;
  Box<SettingsState> get boxSettingsState => data.boxSettingsState!;

  AppState get data {
    return dependOnInheritedWidgetOfExactType<AppStateScope>()!.data;
  }

  AppStateWidgetState get view {
    return findAncestorStateOfType<AppStateWidgetState>()!;
  }

  set patient(Patient? patient) => data.currentUser = patient;
  set userState(UserState? userState) => data.userState = userState;
  set settingsState(SettingsState? settings) => data.settingsState = settings;

  void refresh() => findAncestorStateOfType<AppStateWidgetState>()!.refresh();

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

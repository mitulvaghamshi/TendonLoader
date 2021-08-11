import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/screens/login.dart';

extension ExCell on String {
  DataCell get toCell => DataCell(Text(this, style: const TextStyle(fontSize: 16)));
}

extension ExAppState on BuildContext {
  Patient get patient => data.currentUser!;
  UserState get userState => data.userState!;
  SettingsState get settingsState => data.settingsState!;
  AppState get data => dependOnInheritedWidgetOfExactType<AppStateScope>()!.data;

  set patient(Patient? patient) => data.currentUser = patient;
  set userState(UserState? userState) => data.userState = userState;
  set settingsState(SettingsState? settings) => data.settingsState = settings;

  void refresh() => findAncestorStateOfType<AppStateWidgetState>()!.refresh();

  void showSnackBar(Widget content) => ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: content));

  Future<void> logout() async => Navigator.pushNamedAndRemoveUntil<void>(this, Login.route, (_) => false);

  void pop<T extends Object?>([T? result]) => Navigator.pop<T>(this, result);

  Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) =>
      Navigator.pushNamed<T>(this, routeName, arguments: arguments);

  Future<T?> replace<T extends Object?>(String routeName, {Object? arguments}) =>
      Navigator.pushReplacementNamed<T, T>(this, routeName, arguments: arguments);
}

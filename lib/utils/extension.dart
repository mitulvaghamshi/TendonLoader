import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/common.dart';

extension ExString on String {
  DataCell get toCell {
    return DataCell(Text(this, style: const TextStyle(fontSize: 16)));
  }
}

extension ExContext on BuildContext {
  // Patient get patient => currentUser!;
  // set patient(Patient? patient) => currentUser = patient;

  // UserState get userState => userState;
  // set userState(UserState? userState) => userState = userState;

  // SettingsState get settingsState => settingsState;
  // set settingsState(SettingsState? settings) => settingsState = settings;



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

  Future<T?> popup<T extends Object?>(
    String routeName, {
    bool? isFullScreen = true,
    Object? arguments,
  }) {
    return Navigator.push<T>(this, buildRoute<T>(routeName, isFullScreen));
  }
}

import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state.dart';

class AppStateScope extends InheritedWidget {
  const AppStateScope(this.data, {Key? key, required Widget child}) : super(key: key, child: child);

  final AppState data;

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateScope>()!.data;
  }

  @override
  bool updateShouldNotify(AppStateScope oldWidget) {
    return data != oldWidget.data;
  }
}

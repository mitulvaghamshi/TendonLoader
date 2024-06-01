import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/states/app_state.dart';

@immutable
final class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.data, required super.child});

  final AppState data;

  static AppState of(BuildContext context) {
    final AppScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();
    if (scope == null) throw 'No AppState in scope!';
    return scope.data;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget is AppScope && (data != oldWidget.data);
}

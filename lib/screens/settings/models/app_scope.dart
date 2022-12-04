import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';

@immutable
class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.data, required super.child});

  final AppState data;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is AppScope && data != oldWidget.data;
  }
}

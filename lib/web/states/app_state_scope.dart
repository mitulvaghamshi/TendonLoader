import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/models/patient.dart';

@immutable
class AppStateScope extends InheritedWidget {
  const AppStateScope({super.key, required this.data, required super.child});

  final AppState data;

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateScope>()!.data;
  }

  @override
  bool updateShouldNotify(AppStateScope oldWidget) {
    return true;
  }
}

class AppState {
  final Map<int, Patient> users = HashMap<int, Patient>();
}

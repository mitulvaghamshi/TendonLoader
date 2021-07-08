import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state.dart';

@immutable
class AppStateScope extends InheritedWidget {
  const AppStateScope({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final AppState data;

  @override
  bool updateShouldNotify(AppStateScope oldWidget) => oldWidget.data != data;
}

import 'package:flutter/material.dart';
import 'package:tendon_loader/state/app_state.dart';

@immutable
class AppScope extends InheritedWidget {
  const AppScope({required this.data, required super.child, super.key});

  final AppState data;

  static AppState of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    return ArgumentError.checkNotNull(scope, 'State not initialized').data;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget is AppScope && data != oldWidget.data;
}

extension StateReader on BuildContext {
  T read<T>() {
    if (T == AppState) {
      return AppScope.of(this) as T;
    } else {
      throw UnimplementedError('Type: $T is not implemented!');
    }
  }
}

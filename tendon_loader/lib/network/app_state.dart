import 'package:flutter/foundation.dart';
import 'package:tendon_loader/network/api.dart';

enum Category { excercise, settings }

@immutable
final class AppState {
  const AppState({required this.api});

  final Api api;

  AppState copyWith({final Api? api}) => AppState(api: api ?? this.api);
}

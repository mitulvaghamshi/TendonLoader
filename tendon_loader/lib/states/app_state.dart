import 'package:flutter/foundation.dart';
import 'package:tendon_loader/states/app_service.dart';

enum Category { excercise, settings }

@immutable
final class AppState {
  const AppState({required this.service});

  AppState.empty() : service = AppService.empty();

  final AppService service;

  AppState copyWith({final AppService? service}) =>
      AppState(service: service ?? this.service);
}

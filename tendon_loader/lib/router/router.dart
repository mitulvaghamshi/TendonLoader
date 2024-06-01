import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/api/services/prescription_service.dart';
import 'package:tendon_loader/handlers/bluetooth_handler.dart';
import 'package:tendon_loader/handlers/exercise_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/handlers/livedata_handler.dart';
import 'package:tendon_loader/handlers/mvc_handler.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/ui/dataview/exercise_data_list.dart';
import 'package:tendon_loader/ui/dataview/exercise_detail.dart';
import 'package:tendon_loader/ui/dataview/exercise_list.dart';
import 'package:tendon_loader/ui/dataview/user_list.dart';
import 'package:tendon_loader/ui/homescreen.dart';
import 'package:tendon_loader/ui/screens/exercise_mode.dart';
import 'package:tendon_loader/ui/screens/live_data.dart';
import 'package:tendon_loader/ui/screens/mvc_testing.dart';
import 'package:tendon_loader/ui/screens/new_mvc_test.dart';
import 'package:tendon_loader/ui/screens/prescription_screen.dart';
import 'package:tendon_loader/ui/screens/prompt_screen.dart';
import 'package:tendon_loader/ui/screens/settings_screen.dart';
import 'package:tendon_loader/ui/screens/signin_screen.dart';
import 'package:tendon_loader/ui/widgets/future_handler.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/states/app_scope.dart';

part 'router.g.dart';

@TypedGoRoute<TendonLoaderRoute>(path: '/', routes: [
  TypedGoRoute<SettingScreenRoute>(path: 'settings'),
  //
  TypedGoRoute<LiveDataRoute>(path: 'livedata'),
  //
  TypedGoRoute<NewMVCTestRoute>(path: 'newmvctest'),
  TypedGoRoute<MVCTestingRoute>(path: 'mvctesting'),
  //
  TypedGoRoute<NewExerciseRoute>(path: 'newexercise'),
  TypedGoRoute<ExerciseModeRoute>(path: 'exercisemode'),
  TypedGoRoute<PromptScreenRoute>(path: 'promptscreen'),
  //
  TypedGoRoute<UserListRoute>(path: 'userlist'),
  TypedGoRoute<ExerciseListRoute>(path: 'exerciselist'),
  TypedGoRoute<ExerciseDetaildRoute>(path: 'exercisedetail'),
  TypedGoRoute<ExerciseDataListRoute>(path: 'exercisedatalist'),
])
@immutable
final class TendonLoaderRoute extends GoRouteData with Progressor {
  const TendonLoaderRoute();

  @override
  FutureOr<bool> onExit(BuildContext context, GoRouterState state) {
    disconnect();
    return super.onExit(context, state);
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tendon Loader')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SignInScreen(builder: (_) => const HomeScreen()),
      ),
    );
  }
}

@immutable
final class SettingScreenRoute extends GoRouteData {
  const SettingScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

@immutable
final class NewMVCTestRoute extends GoRouteData {
  const NewMVCTestRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const NewMVCTest();
}

@immutable
final class NewExerciseRoute extends GoRouteData {
  const NewExerciseRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final id = AppScope.of(context).settings.prescriptionId;
    if (id == null) return const RawButton.error();
    return FutureHandler(
      future: PrescriptionService.get(id: id),
      builder: (value) => PrescriptionScreen(prescription: value),
    );
  }
}

@immutable
final class PromptScreenRoute extends GoRouteData {
  const PromptScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PromptScreen();
}

@immutable
final class UserListRoute extends GoRouteData {
  const UserListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const UserList();
}

@immutable
final class ExerciseListRoute extends GoRouteData {
  const ExerciseListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    if (state.extra
        case {'userId': final int userId, 'title': final String title}) {
      return ExerciseList(userId: userId, title: title);
    }
    return const RawButton.error();
  }
}

@immutable
final class ExerciseDetaildRoute extends GoRouteData {
  const ExerciseDetaildRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    if (state.extra
        case {'userId': final int userId, 'exerciseId': final int exerciseId}) {
      return ExerciseDetail(userId: userId, exerciseId: exerciseId);
    }
    return const RawButton.error();
  }
}

@immutable
final class ExerciseDataListRoute extends GoRouteData {
  const ExerciseDataListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    if (state.extra
        case {'userId': final int userId, 'exerciseId': final int exerciseId}) {
      return ExerciseDataList(userId: userId, exerciseId: exerciseId);
    }
    return const RawButton.error();
  }
}

@immutable
final class LiveDataRoute extends GoRouteData {
  const LiveDataRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final handler = LiveDataHandler(onCountdown: context._countdown);
    return LiveData(handler: handler);
  }
}

@immutable
final class MVCTestingRoute extends GoRouteData {
  const MVCTestingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final handler = MVCHandler(
      mvcDuration: 0,
      onCountdown: context._countdown,
    );
    return MVCTesting(handler: handler);
  }
}

@immutable
final class ExerciseModeRoute extends GoRouteData {
  const ExerciseModeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final handler = ExerciseHandler(
      prescription: const Prescription.empty(),
      onCountdown: context._countdown,
    );
    return ExerciseMode(handler: handler);
  }
}

extension on BuildContext {
  Future<bool?> _countdown(final String title, final Duration duration) async =>
      startCountdown(context: this, title: title, duration: duration);
}

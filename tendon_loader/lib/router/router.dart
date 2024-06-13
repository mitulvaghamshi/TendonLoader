import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/handlers/bluetooth_handler.dart';
import 'package:tendon_loader/handlers/exercise_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/handlers/livedata_handler.dart';
import 'package:tendon_loader/handlers/mvc_handler.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/services/api/network_status.dart';
import 'package:tendon_loader/services/prescription_service.dart';
import 'package:tendon_loader/services/settings_service.dart';
import 'package:tendon_loader/ui/dataview/exercise_data_list.dart';
import 'package:tendon_loader/ui/dataview/exercise_detail.dart';
import 'package:tendon_loader/ui/dataview/exercise_list.dart';
import 'package:tendon_loader/ui/dataview/user_list.dart';
import 'package:tendon_loader/ui/screens/homescreen.dart';
import 'package:tendon_loader/ui/screens/new_mvc_test.dart';
import 'package:tendon_loader/ui/screens/prescription_screen.dart';
import 'package:tendon_loader/ui/screens/prompt_screen.dart';
import 'package:tendon_loader/ui/screens/settings_screen.dart';
import 'package:tendon_loader/ui/screens/signin_screen.dart';
import 'package:tendon_loader/ui/widgets/countdown_widget.dart';
import 'package:tendon_loader/ui/widgets/future_wrapper.dart';
import 'package:tendon_loader/ui/widgets/graph_widget.dart';
import 'package:tendon_loader/ui/widgets/life_cycle_aware.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/states/app_scope.dart';

part 'router.g.dart';

@TypedGoRoute<TendonLoaderRoute>(path: TendonLoaderRoute.path, routes: [
  TypedGoRoute<InvalidRoute>(path: InvalidRoute.path),
  //
  TypedGoRoute<SettingScreenRoute>(path: SettingScreenRoute.path),
  //
  TypedGoRoute<LiveDataRoute>(path: LiveDataRoute.path),
  //
  TypedGoRoute<NewMVCTestRoute>(path: NewMVCTestRoute.path),
  TypedGoRoute<MVCTestingRoute>(path: MVCTestingRoute.path),
  //
  TypedGoRoute<NewExerciseRoute>(path: NewExerciseRoute.path),
  TypedGoRoute<ExerciseModeRoute>(path: ExerciseModeRoute.path),
  TypedGoRoute<PromptScreenRoute>(path: PromptScreenRoute.path),
  //
  TypedGoRoute<UserListRoute>(path: UserListRoute.path),
  TypedGoRoute<ExerciseListRoute>(path: ExerciseListRoute.path),
  TypedGoRoute<ExerciseDetaildRoute>(path: ExerciseDetaildRoute.path),
  TypedGoRoute<ExerciseDataListRoute>(path: ExerciseDataListRoute.path),
])
@immutable
class TendonLoaderRoute extends GoRouteData {
  const TendonLoaderRoute();

  static const path = '/';

  @override
  FutureOr<bool> onExit(BuildContext context, GoRouterState state) async {
    NetworkStatus.instance.dispose();
    Progressor.instance.disconnect();
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
class InvalidRoute extends GoRouteData {
  const InvalidRoute({required this.message});

  final String message;

  static const path = 'invalid';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RawButton.error(message: message);
}

@immutable
class SettingScreenRoute extends GoRouteData {
  const SettingScreenRoute();

  static const path = 'settings';

  @override
  FutureOr<bool> onExit(BuildContext context, GoRouterState state) async {
    final appState = AppScope.of(context);
    if (appState.modified) {
      appState.modified = false;
      SettingsService.instance.updateSettings(appState.settings);
    }
    return super.onExit(context, state);
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: SettingsScreen(),
      ),
    );
  }
}

@immutable
class LiveDataRoute extends GoRouteData {
  const LiveDataRoute();

  static const name = 'Live Data';
  static const path = 'livedata';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final handler = LiveDataHandler(onCountdown: context._countdown);
    return GraphWidget(
      title: name,
      handler: handler,
      builder: (_) => Text(
        handler.timeElapsed,
        textAlign: TextAlign.center,
        style: Styles.blackBold40,
      ),
    );
  }
}

@immutable
class NewMVCTestRoute extends GoRouteData {
  const NewMVCTestRoute();

  static const path = 'newmvctest';

  @override
  Widget build(BuildContext context, GoRouterState state) => const NewMVCTest();
}

@immutable
class MVCTestingRoute extends GoRouteData {
  const MVCTestingRoute();

  static const name = 'MVC Testing';
  static const path = 'mvctesting';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final handler = MVCHandler(mvcDuration: 0, onCountdown: context._countdown);
    return GraphWidget(
      title: name,
      handler: handler,
      builder: (_) => Column(children: [
        Text(handler.maxForceValue, style: Styles.blackBold40),
        Text(
          handler.timeDiffValue,
          style: Styles.blackBold40.copyWith(color: const Color(0xffff534d)),
        ),
      ]),
    );
  }
}

@immutable
class NewExerciseRoute extends GoRouteData {
  const NewExerciseRoute();

  static const path = 'newexercise';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final id = AppScope.of(context).settings.prescriptionId;
    if (id == null) return const RawButton.error();
    return FutureWrapper(
      future: PrescriptionService.instance.getPrescriptionById(id),
      builder: (value) => PrescriptionScreen(prescription: value.requireData),
    );
  }
}

@immutable
class ExerciseModeRoute extends GoRouteData {
  const ExerciseModeRoute();

  static const name = 'Exercise Mode';
  static const path = 'exercisemode';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final handler = ExerciseHandler(
      prescription: const Prescription.empty(),
      onCountdown: context._countdown,
    );
    return LifeCycleAware(
      onPause: () {
        handler.pause();
        // Stop progressor after 1 minute on inactivity
        Future<void>.delayed(const Duration(minutes: 1), () {
          if (isPause) handler.stop();
        });
      },
      onResume: () {
        if (handler.isRunning) handler.start();
      },
      builder: (_) => GraphWidget(
        title: name,
        handler: handler,
        builder: (_) => Column(children: [
          Text(handler.timeCounter, style: handler.timeStyle),
          const Divider(),
          const Row(children: [
            Expanded(child: Text('Rep:', style: Styles.blackBold)),
            Expanded(child: Text('Set:', style: Styles.blackBold)),
          ]),
          Row(children: [
            Expanded(
              child: Text(
                handler.repCounter,
                textAlign: TextAlign.center,
                style: Styles.blackBold40,
              ),
            ),
            Expanded(
              child: Text(
                handler.setCounter,
                textAlign: TextAlign.center,
                style: Styles.blackBold40,
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

@immutable
class PromptScreenRoute extends GoRouteData {
  const PromptScreenRoute();

  static const path = 'promptscreen';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PromptScreen();
}

@immutable
class UserListRoute extends GoRouteData {
  const UserListRoute();

  static const path = 'userlist';

  @override
  Widget build(BuildContext context, GoRouterState state) => const UserList();
}

@immutable
class ExerciseListRoute extends GoRouteData {
  const ExerciseListRoute({required this.userId, required this.title});

  final int userId;
  final String title;

  static const path = 'exerciselist';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ExerciseList(userId: userId, title: title);
}

@immutable
class ExerciseDetaildRoute extends GoRouteData {
  const ExerciseDetaildRoute({required this.userId, required this.exerciseId});

  final int userId;
  final int exerciseId;

  static const path = 'exercisedetail';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ExerciseDetail(userId: userId, exerciseId: exerciseId);
}

@immutable
class ExerciseDataListRoute extends GoRouteData {
  const ExerciseDataListRoute({required this.userId, required this.exerciseId});

  final int userId;
  final int exerciseId;

  static const path = 'exercisedatalist';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ExerciseDataList(userId: userId, exerciseId: exerciseId);
}

extension on BuildContext {
  Future<bool?> _countdown(final String title, final Duration duration) async {
    return showDialog<bool>(
      context: this,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(title, style: Styles.bold18),
          ),
          CountdownWidget(duration: duration),
          RawButton.tile(
            onTap: context.pop,
            leading: const Icon(Icons.clear, color: Color(0xffff534d)),
            child: const Text('Cancel'),
          ),
        ]),
      ),
    );
  }
}

import 'dart:async' show Future, FutureOr;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/api/network_status.dart';
import 'package:tendon_loader/handlers/bluetooth_handler.dart';
import 'package:tendon_loader/handlers/exercise_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/handlers/livedata_handler.dart';
import 'package:tendon_loader/handlers/mvc_handler.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/services/exercise_service.dart';
import 'package:tendon_loader/services/prescription_service.dart';
import 'package:tendon_loader/services/settings_service.dart';
import 'package:tendon_loader/services/user_service.dart';
import 'package:tendon_loader/states/app_scope.dart';
import 'package:tendon_loader/ui/dataview/exercise_data_list.dart';
import 'package:tendon_loader/ui/dataview/exercise_detail.dart';
import 'package:tendon_loader/ui/dataview/exercise_list.dart';
import 'package:tendon_loader/ui/dataview/user_list.dart';
import 'package:tendon_loader/ui/screens/homescreen.dart';
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

part 'router.g.dart';

@TypedGoRoute<TendonLoaderRoute>(path: TendonLoaderRoute.path, routes: [
  TypedGoRoute<SettingScreenRoute>(path: SettingScreenRoute.path),
  TypedGoRoute<PrescriptionRoute>(path: PrescriptionRoute.path),
  //
  TypedGoRoute<LiveDataRoute>(path: LiveDataRoute.path),
  //
  TypedGoRoute<MVCTestingRoute>(path: MVCTestingRoute.path),
  //
  TypedGoRoute<ExerciseModeRoute>(path: ExerciseModeRoute.path),
  //
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
class SettingScreenRoute extends GoRouteData {
  const SettingScreenRoute();

  static const name = 'Settings';
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
class PrescriptionRoute extends GoRouteData {
  const PrescriptionRoute();

  static const path = 'prescriptions';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final prescription = AppScope.of(context).prescription;
    return Scaffold(
      appBar: AppBar(title: const Text('Prescriptions')),
      body: PrescriptionScreen(prescription: prescription),
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
class MVCTestingRoute extends GoRouteData {
  const MVCTestingRoute();

  static const name = 'MVC Testing';
  static const path = 'mvctesting';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final handler = MVCHandler(
      mvcDuration: AppScope.of(context).prescription.mvcDuration,
      onCountdown: context._countdown,
    );
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
      onPause: () async {
        handler.pause();
        await Future<void>.delayed(const Duration(minutes: 1), () {
          // Stop progressor after 1 minute on inactivity
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
  Widget build(BuildContext context, GoRouterState state) {
    return FutureWrapper(
      future: UserService.instance.getAllUsers(),
      builder: (snapshot) {
        if (snapshot.hasData) return UserList(items: snapshot.requireData);
        return RawButton.error(message: snapshot.error.toString());
      },
    );
  }
}

@immutable
class ExerciseListRoute extends GoRouteData {
  const ExerciseListRoute({required this.userId, required this.title});

  final int userId;
  final String title;

  static const path = 'exerciselist';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FutureWrapper(
      future: ExerciseService.instance.getAllExercisesByUserId(userId),
      builder: (snapshot) => ExerciseList(
        title: title,
        items: snapshot.requireData,
      ),
    );
  }
}

@immutable
class ExerciseDetaildRoute extends GoRouteData {
  const ExerciseDetaildRoute({required this.userId, required this.exerciseId});

  final int userId;
  final int exerciseId;

  static const path = 'exercisedetail';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FutureWrapper(
      future: _future,
      builder: (data) => ExerciseDetail(payload: data),
    );
  }

  Future<ExercisePayload> get _future async {
    final eSnapshot = await ExerciseService.instance
        .getExerciseBy(userId: userId, exerciseId: exerciseId);

    if (eSnapshot.hasError) {
      return (
        targetLoad: 0.0,
        chartData: const Iterable<ChartData>.empty(),
        infoTable: const Iterable<(String, String)>.empty(),
      );
    }

    final exercise = eSnapshot.requireData;

    final pSnapshot = await PrescriptionService.instance
        .getPrescriptionById(exercise.prescriptionId);

    if (pSnapshot.hasError) {
      return (
        targetLoad: exercise.mvcValue ?? 0.0,
        chartData: exercise.data,
        infoTable: exercise.tableRows,
      );
    }

    final prescription = pSnapshot.requireData;
    return (
      targetLoad: prescription.targetLoad,
      chartData: exercise.data,
      infoTable: [...exercise.tableRows, ...prescription.tableRows],
    );
  }
}

@immutable
class ExerciseDataListRoute extends GoRouteData {
  const ExerciseDataListRoute({required this.userId, required this.exerciseId});

  final int userId;
  final int exerciseId;

  static const path = 'exercisedatalist';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FutureWrapper(
      future: _future,
      builder: (items) => ExerciseDataList(items: items),
    );
  }

  Future<Iterable<ChartData>> get _future async {
    final eSnapshot = await ExerciseService.instance
        .getExerciseBy(userId: userId, exerciseId: exerciseId);
    if (eSnapshot.hasData) return eSnapshot.requireData.data;
    return const Iterable.empty();
  }
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

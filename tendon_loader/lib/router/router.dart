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
import 'package:tendon_loader/ui/widgets/app_frame.dart';
import 'package:tendon_loader/ui/widgets/button_factory.dart';
import 'package:tendon_loader/ui/widgets/countdown_widget.dart';
import 'package:tendon_loader/ui/widgets/future_wrapper.dart';
import 'package:tendon_loader/ui/widgets/graph_widget.dart';
import 'package:tendon_loader/ui/widgets/life_cycle_aware.dart';
import 'package:tendon_loader/utils/constants.dart';

part 'router.g.dart';

@TypedGoRoute<TendonLoaderRoute>(
  path: TendonLoaderRoute.path,
  routes: [
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
  ],
)
@immutable
class TendonLoaderRoute extends GoRouteData with $TendonLoaderRoute {
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
    NetworkStatus(); // Initialize Singleton.

    return Scaffold(
      appBar: AppBar(title: const Text('Tendon Loader')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: AppFrame(child: SignInScreen(child: HomeScreen())),
      ),
    );
  }
}

@immutable
class SettingScreenRoute extends GoRouteData with $SettingScreenRoute {
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
        child: AppFrame(child: SettingsScreen()),
      ),
    );
  }
}

@immutable
class PrescriptionRoute extends GoRouteData with $PrescriptionRoute {
  const PrescriptionRoute();

  static const path = 'prescriptions';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final prescription = AppScope.of(context).prescription;
    return Scaffold(
      appBar: AppBar(title: const Text('Prescriptions')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AppFrame(child: PrescriptionScreen(prescription: prescription)),
      ),
    );
  }
}

@immutable
class LiveDataRoute extends GoRouteData with $LiveDataRoute {
  const LiveDataRoute();

  static const name = 'Live Data';
  static const path = 'livedata';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final handler = LiveDataHandler(onCountdown: context._countdown);
    return GraphWidget(
      title: name,
      handler: handler,
      headerBuilder: (_) {
        return Text(
          handler.timeElapsed,
          textAlign: TextAlign.center,
          style: Styles.blackBold26,
        );
      },
    );
  }
}

@immutable
class MVCTestingRoute extends GoRouteData with $MVCTestingRoute {
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
      headerBuilder: (_) {
        return Column(
          children: [
            Text(handler.maxForceValue, style: Styles.blackBold26),
            Text(
              handler.timeDiffValue,
              style: Styles.blackBold26.copyWith(
                color: const Color(0xffff534d),
              ),
            ),
          ],
        );
      },
    );
  }
}

@immutable
class ExerciseModeRoute extends GoRouteData with $ExerciseModeRoute {
  const ExerciseModeRoute();

  static const name = 'Exercise Mode';
  static const path = 'exercisemode';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final handler = ExerciseHandler(
      prescription: AppScope.of(context).prescription,
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
      builder: (_) {
        return GraphWidget(
          title: name,
          handler: handler,
          headerBuilder: (_) {
            return SizedBox(
              width: 300,
              child: Column(
                children: [
                  Text(handler.timeCounter, style: handler.timeStyle),
                  Divider(color: handler.feedColor, thickness: 10),
                  const Row(
                    children: [
                      Expanded(child: Text('Rep:')),
                      Expanded(child: Text('Set:')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          handler.repCounter,
                          textAlign: TextAlign.center,
                          style: Styles.blackBold26,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          handler.setCounter,
                          textAlign: TextAlign.center,
                          style: Styles.blackBold26,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

@immutable
class PromptScreenRoute extends GoRouteData with $PromptScreenRoute {
  const PromptScreenRoute();

  static const path = 'promptscreen';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PromptScreen();
}

@immutable
class UserListRoute extends GoRouteData with $UserListRoute {
  const UserListRoute();

  static const path = 'userlist';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: FutureWrapper(
        future: UserService.instance.getAllUsers(),
        builder: (snapshot) {
          if (snapshot.hasData) return UserList(items: snapshot.requireData);
          return ButtonFactory.error(message: snapshot.error.toString());
        },
      ),
    );
  }
}

@immutable
class ExerciseListRoute extends GoRouteData with $ExerciseListRoute {
  const ExerciseListRoute({required this.userId, required this.title});

  final int userId;
  final String title;

  static const path = 'exerciselist';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: FutureWrapper(
        future: ExerciseService.instance.getAllExercisesByUserId(userId),
        builder: (snapshot) {
          return ExerciseList(title: title, items: snapshot.requireData);
        },
      ),
    );
  }
}

@immutable
class ExerciseDetaildRoute extends GoRouteData with $ExerciseDetaildRoute {
  const ExerciseDetaildRoute({required this.userId, required this.exerciseId});

  final int userId;
  final int exerciseId;

  static const path = 'exercisedetail';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: FutureWrapper(
        future: _future,
        builder: (data) {
          return ExerciseDetail(payload: data);
        },
      ),
    );
  }

  Future<ExercisePayload> get _future async {
    final eSnapshot = await ExerciseService.instance.getExerciseBy(
      userId: userId,
      exerciseId: exerciseId,
    );

    if (eSnapshot.hasError) {
      return (
        targetLoad: 0.0,
        chartData: const Iterable<ChartData>.empty(),
        infoTable: const Iterable<(String, String)>.empty(),
      );
    }

    final exercise = eSnapshot.requireData;

    final pSnapshot = await PrescriptionService.instance.getPrescriptionById(
      exercise.prescriptionId,
    );

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
class ExerciseDataListRoute extends GoRouteData with $ExerciseDataListRoute {
  const ExerciseDataListRoute({required this.userId, required this.exerciseId});

  final int userId;
  final int exerciseId;

  static const path = 'exercisedatalist';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: FutureWrapper(
        future: _future,
        builder: (items) {
          return ExerciseDataList(items: items);
        },
      ),
    );
  }

  Future<Iterable<ChartData>> get _future async {
    final eSnapshot = await ExerciseService.instance.getExerciseBy(
      userId: userId,
      exerciseId: exerciseId,
    );
    if (eSnapshot.hasData) return eSnapshot.requireData.data;
    return const Iterable.empty();
  }
}

extension on BuildContext {
  Future<bool?> _countdown(String title, Duration duration) async {
    return showDialog<bool>(
      context: this,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(title, style: Styles.bold18),
              ),
              CountdownWidget(duration: duration),
              ButtonFactory.tile(
                onTap: context.pop,
                leading: const Icon(Icons.clear, color: Color(0xffff534d)),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }
}

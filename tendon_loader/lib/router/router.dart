import 'dart:async' show Future, FutureOr;

import 'package:api_server/api_server.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/api/network_status.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader/handler/exercise_handler.dart';
import 'package:tendon_loader/handler/graph_handler.dart';
import 'package:tendon_loader/handler/livedata_handler.dart';
import 'package:tendon_loader/handler/mvc_handler.dart';
import 'package:tendon_loader/pages/dataview/exercise_data_list.dart';
import 'package:tendon_loader/pages/dataview/exercise_detail.dart';
import 'package:tendon_loader/pages/dataview/exercise_list.dart';
import 'package:tendon_loader/pages/dataview/user_list.dart';
import 'package:tendon_loader/pages/screens/home_screen.dart';
import 'package:tendon_loader/pages/screens/prescription_screen.dart';
import 'package:tendon_loader/pages/screens/prompt_screen.dart';
import 'package:tendon_loader/pages/screens/settings_screen.dart';
import 'package:tendon_loader/pages/screens/signin_screen.dart';
import 'package:tendon_loader/pages/widgets/app_frame.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';
import 'package:tendon_loader/pages/widgets/countdown_widget.dart';
import 'package:tendon_loader/pages/widgets/future_wrapper.dart';
import 'package:tendon_loader/pages/widgets/graph_widget.dart';
import 'package:tendon_loader/pages/widgets/life_cycle_aware.dart';
import 'package:tendon_loader/service/exercise_service.dart';
import 'package:tendon_loader/service/prescription_service.dart';
import 'package:tendon_loader/service/settings_service.dart';
import 'package:tendon_loader/service/user_service.dart';
import 'package:tendon_loader/state/app_scope.dart';
import 'package:tendon_loader/state/app_state.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/utils.dart';

part 'router.g.dart';

@TypedGoRoute<TendonLoaderRoute>(
  path: TendonLoaderRoute.path,
  routes: [
    TypedGoRoute<SettingScreenRoute>(path: SettingScreenRoute.path),
    TypedGoRoute<PrescriptionRoute>(path: PrescriptionRoute.path),
    TypedGoRoute<LiveDataRoute>(path: LiveDataRoute.path),
    TypedGoRoute<MVCTestingRoute>(path: MVCTestingRoute.path),
    TypedGoRoute<ExerciseModeRoute>(path: ExerciseModeRoute.path),
    TypedGoRoute<PromptScreenRoute>(path: PromptScreenRoute.path),
    TypedGoRoute<UserListRoute>(path: UserListRoute.path),
    TypedGoRoute<ExerciseListRoute>(path: ExerciseListRoute.path),
    TypedGoRoute<ExerciseDetailsRoute>(path: ExerciseDetailsRoute.path),
    TypedGoRoute<ExerciseDataListRoute>(path: ExerciseDataListRoute.path),
  ],
)
@immutable
class TendonLoaderRoute extends GoRouteData with $TendonLoaderRoute {
  const TendonLoaderRoute();

  static const name = 'Tendon Loader';
  static const path = '/';

  @override
  FutureOr<bool> onExit(BuildContext context, GoRouterState state) async {
    NetworkStatus.instance.dispose();
    Progressor.instance.disconnect();

    return super.onExit(context, state);
  }

  @override
  Widget build(BuildContext context, GoRouterState state) => Scaffold(
    appBar: AppBar(title: const Text('Tendon Loader')),
    body: const SingleChildScrollView(
      padding: .all(16),
      child: AppFrame(child: SignInScreen(child: HomeScreen())),
    ),
  );
}

@immutable
class SettingScreenRoute extends GoRouteData with $SettingScreenRoute {
  const SettingScreenRoute();

  static const name = 'Settings';
  static const path = 'settings';

  @override
  FutureOr<bool> onExit(BuildContext context, GoRouterState state) async {
    final appState = context.read<AppState>();
    if (appState.modified) {
      appState.modified = false;
      SettingsService.instance.updateSettings(appState.settings);
    }
    return super.onExit(context, state);
  }

  @override
  Widget build(BuildContext context, GoRouterState state) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: const SingleChildScrollView(
      padding: .all(16),
      child: AppFrame(child: SettingsScreen()),
    ),
  );
}

@immutable
class PrescriptionRoute extends GoRouteData with $PrescriptionRoute {
  const PrescriptionRoute();

  static const path = 'prescriptions';

  @override
  Widget build(BuildContext context, GoRouterState state) => Scaffold(
    appBar: AppBar(title: const Text('Prescriptions')),
    body: SingleChildScrollView(
      padding: const .all(16),
      child: AppFrame(
        child: PrescriptionScreen(
          prescription: context.read<AppState>().prescription,
        ),
      ),
    ),
  );
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
      headerBuilder: (_) => Text(
        handler.timeElapsed,
        textAlign: .center,
        style: Styles.blackBold26,
      ),
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
      mvcDuration: context.read<AppState>().prescription.mvcDuration,
      onCountdown: context._countdown,
    );
    return GraphWidget(
      title: name,
      handler: handler,
      headerBuilder: (_) => Column(
        children: [
          Text(handler.maxForceValue, style: Styles.blackBold26),
          Text(
            handler.timeDiffValue,
            style: Styles.blackBold26.copyWith(color: const Color(0xffff534d)),
          ),
        ],
      ),
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
      prescription: context.read<AppState>().prescription,
      onCountdown: context._countdown,
    );
    return LifeCycleAware(
      onPause: () async {
        handler.pause();
        // Stop progressor after 1 minute on inactivity
        await Future.delayed(const .new(minutes: 1), () {
          if (isPause) {
            handler.stop();
          }
        });
      },
      onResume: () {
        if (handler.isSessionRunning) {
          handler.start();
        }
      },
      builder: (_) => GraphWidget(
        title: name,
        handler: handler,
        headerBuilder: (_) => SizedBox(
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
                      textAlign: .center,
                      style: Styles.blackBold26,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      handler.setCounter,
                      textAlign: .center,
                      style: Styles.blackBold26,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
  Widget build(BuildContext context, GoRouterState state) => Scaffold(
    body: FutureWrapper(
      future: UserService.instance.getAllUsers(),
      builder: (snapshot) {
        if (snapshot.data case Iterable<User> users) {
          return UserList(items: users);
        }
        return const ButtonFactory.error(message: 'Failed to load users');
      },
    ),
  );
}

@immutable
class ExerciseListRoute extends GoRouteData with $ExerciseListRoute {
  const ExerciseListRoute({required this.userId, required this.title});

  final int userId;
  final String title;

  static const path = 'exerciselist';

  @override
  Widget build(BuildContext context, GoRouterState state) => Scaffold(
    body: FutureWrapper(
      future: ExerciseService.instance.getAllExercisesByUserId(userId),
      builder: (snapshot) =>
          ExerciseList(title: title, items: snapshot.requireData),
    ),
  );
}

@immutable
class ExerciseDetailsRoute extends GoRouteData with $ExerciseDetailsRoute {
  const ExerciseDetailsRoute({required this.userId, required this.exerciseId});

  final int userId;
  final int exerciseId;

  static const path = 'exercisedetail';

  @override
  Widget build(BuildContext context, GoRouterState state) => Scaffold(
    body: FutureWrapper(future: _future, builder: ExerciseDetail.new),
  );
}

@immutable
class ExerciseDataListRoute extends GoRouteData with $ExerciseDataListRoute {
  const ExerciseDataListRoute({required this.userId, required this.exerciseId});

  final int userId;
  final int exerciseId;

  static const path = 'exercisedatalist';

  @override
  Widget build(BuildContext context, GoRouterState state) => Scaffold(
    body: FutureWrapper(future: _future, builder: ExerciseDataList.new),
  );
}

extension on ExerciseDataListRoute {
  Future<Iterable<ChartData>> get _future async {
    final eSnapshot = await ExerciseService.instance.getExerciseBy(
      userId: userId,
      exerciseId: exerciseId,
    );
    if (eSnapshot.hasData) {
      return eSnapshot.requireData.data;
    }
    return const Iterable.empty();
  }
}

extension on ExerciseDetailsRoute {
  Future<ExerciseRecord> get _future async {
    final eSnapshot = await ExerciseService.instance.getExerciseBy(
      userId: userId,
      exerciseId: exerciseId,
    );

    if (eSnapshot.hasError) {
      const ExerciseRecord record = (
        targetLoad: 0,
        chartData: .empty(),
        infoTable: .empty(),
      );
      return record;
    }

    final exercise = eSnapshot.requireData;

    final pSnapshot = await PrescriptionService.instance.getPrescriptionById(
      exercise.prescriptionId,
    );

    if (pSnapshot.hasError) {
      final ExerciseRecord record = (
        targetLoad: exercise.mvcValue ?? 0.0,
        chartData: exercise.data,
        infoTable: exercise.tableRows,
      );
      return record;
    }

    final prescription = pSnapshot.requireData;
    final ExerciseRecord record = (
      targetLoad: prescription.targetLoad,
      chartData: exercise.data,
      infoTable: [...exercise.tableRows, ...prescription.tableRows],
    );
    return record;
  }
}

extension on BuildContext {
  Future<bool?> _countdown(String title, Duration duration) => showDialog(
    context: this,
    barrierDismissible: false,
    builder: (context) => Dialog(
      child: Column(
        mainAxisSize: .min,
        children: [
          Padding(
            padding: const .symmetric(vertical: 16),
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
    ),
  );
}

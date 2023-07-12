import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/common/widgets/app_logo.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/network/prescription.dart';
import 'package:tendon_loader/screens/app/homescreen.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise/models/exercise_handler.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/screens/graph/models/graph_handler.dart';
import 'package:tendon_loader/screens/livedata/live_data.dart';
import 'package:tendon_loader/screens/livedata/models/livedata_handler.dart';
import 'package:tendon_loader/screens/mvctest/models/mvc_handler.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/screens/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/screens/prompt/prompt_screen.dart';
import 'package:tendon_loader/screens/settings/settings_screen.dart';
import 'package:tendon_loader/screens/signin/signin.dart';
import 'package:tendon_loader/screens/web/export_list.dart';
import 'package:tendon_loader/screens/web/export_view.dart';
import 'package:tendon_loader/screens/web/homepage.dart';
import 'package:tendon_loader/screens/web/widgets/exercise_history.dart';
import 'package:tendon_loader/screens/web/widgets/session_info.dart';

part 'router.g.dart';

@TypedGoRoute<TendonLoaderRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<SettingScreenRoute>(path: 'settings'),
    TypedGoRoute<HomeScreenRoute>(path: 'homescreen'),
    TypedGoRoute<LiveDataRoute>(path: 'livedata'),
    TypedGoRoute<NewMVCTestRoute>(path: 'newmvctest'),
    TypedGoRoute<MVCTestingRoute>(path: 'mvctesting'),
    TypedGoRoute<NewExerciseRoute>(path: 'newexercise'),
    TypedGoRoute<ExerciseModeRoute>(path: 'exercisemode'),
    TypedGoRoute<PromptScreenRoute>(path: 'promptscreen'),
    //
    TypedGoRoute<HomePageRoute>(path: 'homepage'),
    TypedGoRoute<ExportListRoute>(path: 'exercises'),
    TypedGoRoute<ExportViewRoute>(path: 'exerciseview'),
    TypedGoRoute<SessionInfoRoute>(path: 'sessioninfo'),
    TypedGoRoute<ExerciseHistoryRoute>(path: 'exercisehistory'),
  ],
)
@immutable
class TendonLoaderRoute extends GoRouteData {
  const TendonLoaderRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    const boldStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SignIn(
          builder: (context, user) => Column(children: [
            const AppLogo.padded(),
            RawButton.extended(
              color: Colors.orange,
              child: const Text('Access as a Patient', style: boldStyle),
              onTap: () => const HomeScreenRoute().go(context),
            ),
            const SizedBox(height: 8),
            RawButton.extended(
              color: Colors.orange,
              child: const Text('Clinician - Manage Users', style: boldStyle),
              onTap: () => const HomePageRoute().go(context),
            ),
            const SizedBox(height: 8),
            RawButton.extended(
              color: Colors.green,
              child: const Text('View all settings', style: boldStyle),
              onTap: () => const SettingScreenRoute().push(context),
            ),
          ]),
        ),
      ),
    );
  }
}

@immutable
class SettingScreenRoute extends GoRouteData {
  const SettingScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

@immutable
class HomeScreenRoute extends GoRouteData {
  const HomeScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

@immutable
class NewMVCTestRoute extends GoRouteData {
  const NewMVCTestRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const NewMVCTest();
}

@immutable
class NewExerciseRoute extends GoRouteData {
  const NewExerciseRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NewExercise();
}

@immutable
class PromptScreenRoute extends GoRouteData {
  const PromptScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PromptScreen();
  }
}

@immutable
class HomePageRoute extends GoRouteData {
  const HomePageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

@immutable
class ExerciseHistoryRoute extends GoRouteData {
  const ExerciseHistoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ExerciseHistory();
}

@immutable
class ExportListRoute extends GoRouteData {
  const ExportListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ExportList();
}

@immutable
class ExportViewRoute extends GoRouteData {
  const ExportViewRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ExportView();
}

@immutable
class SessionInfoRoute extends GoRouteData {
  const SessionInfoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SessionInfo();
}

@immutable
class LiveDataRoute extends GoRouteData {
  const LiveDataRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LiveData(
      handler: LiveDataHandler(onCountdown: context.countdown),
    );
  }
}

@immutable
class MVCTestingRoute extends GoRouteData {
  const MVCTestingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MVCTesting(
      handler: MVCHandler(
        mvcDuration: 0,
        onCountdown: context.countdown,
      ),
    );
  }
}

@immutable
class ExerciseModeRoute extends GoRouteData {
  const ExerciseModeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ExerciseMode(
      handler: ExerciseHandler(
        prescription: const Prescription.empty(),
        onCountdown: context.countdown,
      ),
    );
  }
}

extension on BuildContext {
  Future<bool?> countdown(String title, Duration duration) async =>
      startCountdown(context: this, title: title, duration: duration);
}

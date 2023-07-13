import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import 'package:tendon_loader/screens/signin/signin_widget.dart';
import 'package:tendon_loader/screens/signin/welcome_widget.dart';
import 'package:tendon_loader/screens/web/exercise_list.dart';
import 'package:tendon_loader/screens/web/exercise_view.dart';
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
    TypedGoRoute<HomePageRoute>(path: 'homepage'),
    TypedGoRoute<ExportListRoute>(path: 'exercises'),
    TypedGoRoute<ExportViewRoute>(path: 'exerciseview'),
    TypedGoRoute<SessionInfoRoute>(path: 'sessioninfo'),
    TypedGoRoute<ExerciseHistoryRoute>(path: 'exercisehistory'),
  ],
)
@immutable
final class TendonLoaderRoute extends GoRouteData {
  const TendonLoaderRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SignInWidget(builder: () => const WelcomeWidget()),
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
final class HomeScreenRoute extends GoRouteData {
  const HomeScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
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
  Widget build(BuildContext context, GoRouterState state) =>
      const NewExercise();
}

@immutable
final class PromptScreenRoute extends GoRouteData {
  const PromptScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PromptScreen();
}

@immutable
final class HomePageRoute extends GoRouteData {
  const HomePageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

@immutable
final class ExerciseHistoryRoute extends GoRouteData {
  const ExerciseHistoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ExerciseHistory();
}

@immutable
final class ExportListRoute extends GoRouteData {
  const ExportListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ExerciseList();
}

@immutable
final class ExportViewRoute extends GoRouteData {
  const ExportViewRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ExerciseView();
}

@immutable
final class SessionInfoRoute extends GoRouteData {
  const SessionInfoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SessionInfo();
}

@immutable
final class LiveDataRoute extends GoRouteData {
  const LiveDataRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final handler = LiveDataHandler(onCountdown: context.countdown);
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
      onCountdown: context.countdown,
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
      onCountdown: context.countdown,
    );
    return ExerciseMode(handler: handler);
  }
}

extension on BuildContext {
  Future<bool?> countdown(String title, Duration duration) async =>
      startCountdown(context: this, title: title, duration: duration);
}

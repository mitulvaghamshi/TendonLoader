import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/app.dart';
import 'package:tendon_loader/app/exercise/exercise_handler.dart';
import 'package:tendon_loader/app/exercise/exercise_mode.dart';
import 'package:tendon_loader/app/exercise/new_exercise.dart';
import 'package:tendon_loader/app/graph/graph_handler.dart';
import 'package:tendon_loader/app/homescreen.dart';
import 'package:tendon_loader/app/livedata/live_data.dart';
import 'package:tendon_loader/app/livedata/livedata_handler.dart';
import 'package:tendon_loader/app/mvctest/mvc_handler.dart';
import 'package:tendon_loader/app/mvctest/mvc_testing.dart';
import 'package:tendon_loader/app/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/app/prompt/prompt_screen.dart';
import 'package:tendon_loader/app_user/signin_widget.dart';
import 'package:tendon_loader/app_user/user.dart';
import 'package:tendon_loader/clinicial/exercise_list.dart';
import 'package:tendon_loader/clinicial/homepage.dart';
import 'package:tendon_loader/common/widgets/future_handler.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/screens/web/exercise_view.dart';
import 'package:tendon_loader/screens/web/widgets/exercise_history.dart';
import 'package:tendon_loader/screens/web/widgets/session_info.dart';
import 'package:tendon_loader/settings/settings_screen.dart';
import 'package:tendon_loader/states/app_scope.dart';

part 'router.g.dart';

@TypedGoRoute<TendonLoaderRoute>(path: '/', routes: [
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
  TypedGoRoute<ExerciseListRoute>(path: 'exerciselist'),
  TypedGoRoute<ExportViewRoute>(path: 'exerciseview'),
  TypedGoRoute<SessionInfoRoute>(path: 'sessioninfo'),
  TypedGoRoute<ExerciseHistoryRoute>(path: 'exercisehistory'),
])
@immutable
final class TendonLoaderRoute extends GoRouteData {
  const TendonLoaderRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SignInWidget(builder: () => const TendonLoaderApp()),
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
  Widget build(BuildContext context, GoRouterState state) {
    late final service = AppScope.of(context).service;
    return FutureHandler(
      future: service.getUserList(),
      builder: (items) => HomePage(items: service.userList),
    );
  }
}

@immutable
final class ExerciseHistoryRoute extends GoRouteData {
  const ExerciseHistoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ExerciseHistory();
}

@immutable
final class ExerciseListRoute extends GoRouteData {
  const ExerciseListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    late final service = AppScope.of(context).service;
    final user = state.extra as User?;
    if (user == null || user.id == null) {
      return const RawButton(child: Text('Invalid access.'));
    }
    return FutureHandler(
      future: service.getExerciseList(userId: user.id!),
      builder: (items) => ExerciseList(title: user.name, items: items),
    );
  }
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

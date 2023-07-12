// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $tendonLoaderRoute,
    ];

RouteBase get $tendonLoaderRoute => GoRouteData.$route(
      path: '/',
      factory: $TendonLoaderRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'settings',
          factory: $SettingScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'homescreen',
          factory: $HomeScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'livedata',
          factory: $LiveDataRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'newmvctest',
          factory: $NewMVCTestRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'mvctesting',
          factory: $MVCTestingRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'newexercise',
          factory: $NewExerciseRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'exercisemode',
          factory: $ExerciseModeRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'promptscreen',
          factory: $PromptScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'homepage',
          factory: $HomePageRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'exercises',
          factory: $ExportListRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'exerciseview',
          factory: $ExportViewRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'sessioninfo',
          factory: $SessionInfoRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'exercisehistory',
          factory: $ExerciseHistoryRouteExtension._fromState,
        ),
      ],
    );

extension $TendonLoaderRouteExtension on TendonLoaderRoute {
  static TendonLoaderRoute _fromState(GoRouterState state) =>
      const TendonLoaderRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $SettingScreenRouteExtension on SettingScreenRoute {
  static SettingScreenRoute _fromState(GoRouterState state) =>
      const SettingScreenRoute();

  String get location => GoRouteData.$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $HomeScreenRouteExtension on HomeScreenRoute {
  static HomeScreenRoute _fromState(GoRouterState state) =>
      const HomeScreenRoute();

  String get location => GoRouteData.$location(
        '/homescreen',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $LiveDataRouteExtension on LiveDataRoute {
  static LiveDataRoute _fromState(GoRouterState state) => const LiveDataRoute();

  String get location => GoRouteData.$location(
        '/livedata',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $NewMVCTestRouteExtension on NewMVCTestRoute {
  static NewMVCTestRoute _fromState(GoRouterState state) =>
      const NewMVCTestRoute();

  String get location => GoRouteData.$location(
        '/newmvctest',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $MVCTestingRouteExtension on MVCTestingRoute {
  static MVCTestingRoute _fromState(GoRouterState state) =>
      const MVCTestingRoute();

  String get location => GoRouteData.$location(
        '/mvctesting',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $NewExerciseRouteExtension on NewExerciseRoute {
  static NewExerciseRoute _fromState(GoRouterState state) =>
      const NewExerciseRoute();

  String get location => GoRouteData.$location(
        '/newexercise',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $ExerciseModeRouteExtension on ExerciseModeRoute {
  static ExerciseModeRoute _fromState(GoRouterState state) =>
      const ExerciseModeRoute();

  String get location => GoRouteData.$location(
        '/exercisemode',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $PromptScreenRouteExtension on PromptScreenRoute {
  static PromptScreenRoute _fromState(GoRouterState state) =>
      const PromptScreenRoute();

  String get location => GoRouteData.$location(
        '/promptscreen',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $HomePageRouteExtension on HomePageRoute {
  static HomePageRoute _fromState(GoRouterState state) => const HomePageRoute();

  String get location => GoRouteData.$location(
        '/homepage',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $ExportListRouteExtension on ExportListRoute {
  static ExportListRoute _fromState(GoRouterState state) =>
      const ExportListRoute();

  String get location => GoRouteData.$location(
        '/exercises',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $ExportViewRouteExtension on ExportViewRoute {
  static ExportViewRoute _fromState(GoRouterState state) =>
      const ExportViewRoute();

  String get location => GoRouteData.$location(
        '/exerciseview',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $SessionInfoRouteExtension on SessionInfoRoute {
  static SessionInfoRoute _fromState(GoRouterState state) =>
      const SessionInfoRoute();

  String get location => GoRouteData.$location(
        '/sessioninfo',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $ExerciseHistoryRouteExtension on ExerciseHistoryRoute {
  static ExerciseHistoryRoute _fromState(GoRouterState state) =>
      const ExerciseHistoryRoute();

  String get location => GoRouteData.$location(
        '/exercisehistory',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

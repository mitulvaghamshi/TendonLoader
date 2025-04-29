// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$tendonLoaderRoute];

RouteBase get $tendonLoaderRoute => GoRouteData.$route(
  path: '/',
  factory: $TendonLoaderRouteExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: 'settings',
      factory: $SettingScreenRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'prescriptions',
      factory: $PrescriptionRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'livedata',
      factory: $LiveDataRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'mvctesting',
      factory: $MVCTestingRouteExtension._fromState,
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
      path: 'userlist',
      factory: $UserListRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'exerciselist',
      factory: $ExerciseListRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'exercisedetail',
      factory: $ExerciseDetaildRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'exercisedatalist',
      factory: $ExerciseDataListRouteExtension._fromState,
    ),
  ],
);

extension $TendonLoaderRouteExtension on TendonLoaderRoute {
  static TendonLoaderRoute _fromState(GoRouterState state) =>
      const TendonLoaderRoute();

  String get location => GoRouteData.$location('/');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingScreenRouteExtension on SettingScreenRoute {
  static SettingScreenRoute _fromState(GoRouterState state) =>
      const SettingScreenRoute();

  String get location => GoRouteData.$location('/settings');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PrescriptionRouteExtension on PrescriptionRoute {
  static PrescriptionRoute _fromState(GoRouterState state) =>
      const PrescriptionRoute();

  String get location => GoRouteData.$location('/prescriptions');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LiveDataRouteExtension on LiveDataRoute {
  static LiveDataRoute _fromState(GoRouterState state) => const LiveDataRoute();

  String get location => GoRouteData.$location('/livedata');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MVCTestingRouteExtension on MVCTestingRoute {
  static MVCTestingRoute _fromState(GoRouterState state) =>
      const MVCTestingRoute();

  String get location => GoRouteData.$location('/mvctesting');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ExerciseModeRouteExtension on ExerciseModeRoute {
  static ExerciseModeRoute _fromState(GoRouterState state) =>
      const ExerciseModeRoute();

  String get location => GoRouteData.$location('/exercisemode');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PromptScreenRouteExtension on PromptScreenRoute {
  static PromptScreenRoute _fromState(GoRouterState state) =>
      const PromptScreenRoute();

  String get location => GoRouteData.$location('/promptscreen');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UserListRouteExtension on UserListRoute {
  static UserListRoute _fromState(GoRouterState state) => const UserListRoute();

  String get location => GoRouteData.$location('/userlist');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ExerciseListRouteExtension on ExerciseListRoute {
  static ExerciseListRoute _fromState(GoRouterState state) => ExerciseListRoute(
    userId: int.parse(state.uri.queryParameters['user-id']!),
    title: state.uri.queryParameters['title']!,
  );

  String get location => GoRouteData.$location(
    '/exerciselist',
    queryParams: {'user-id': userId.toString(), 'title': title},
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ExerciseDetaildRouteExtension on ExerciseDetaildRoute {
  static ExerciseDetaildRoute _fromState(GoRouterState state) =>
      ExerciseDetaildRoute(
        userId: int.parse(state.uri.queryParameters['user-id']!),
        exerciseId: int.parse(state.uri.queryParameters['exercise-id']!),
      );

  String get location => GoRouteData.$location(
    '/exercisedetail',
    queryParams: {
      'user-id': userId.toString(),
      'exercise-id': exerciseId.toString(),
    },
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ExerciseDataListRouteExtension on ExerciseDataListRoute {
  static ExerciseDataListRoute _fromState(GoRouterState state) =>
      ExerciseDataListRoute(
        userId: int.parse(state.uri.queryParameters['user-id']!),
        exerciseId: int.parse(state.uri.queryParameters['exercise-id']!),
      );

  String get location => GoRouteData.$location(
    '/exercisedatalist',
    queryParams: {
      'user-id': userId.toString(),
      'exercise-id': exerciseId.toString(),
    },
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

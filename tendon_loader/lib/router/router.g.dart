// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$tendonLoaderRoute];

RouteBase get $tendonLoaderRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: true,
  factory: $TendonLoaderRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'settings',
      hasOverriddenOnExit: true,
      factory: $SettingScreenRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'prescriptions',
      hasOverriddenOnExit: false,
      factory: $PrescriptionRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'livedata',
      hasOverriddenOnExit: false,
      factory: $LiveDataRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'mvctesting',
      hasOverriddenOnExit: false,
      factory: $MVCTestingRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'exercisemode',
      hasOverriddenOnExit: false,
      factory: $ExerciseModeRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'promptscreen',
      hasOverriddenOnExit: false,
      factory: $PromptScreenRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'userlist',
      hasOverriddenOnExit: false,
      factory: $UserListRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'exerciselist',
      hasOverriddenOnExit: false,
      factory: $ExerciseListRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'exercisedetail',
      hasOverriddenOnExit: false,
      factory: $ExerciseDetailsRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'exercisedatalist',
      hasOverriddenOnExit: false,
      factory: $ExerciseDataListRoute._fromState,
    ),
  ],
);

mixin $TendonLoaderRoute on GoRouteData {
  static TendonLoaderRoute _fromState(GoRouterState state) =>
      const TendonLoaderRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingScreenRoute on GoRouteData {
  static SettingScreenRoute _fromState(GoRouterState state) =>
      const SettingScreenRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PrescriptionRoute on GoRouteData {
  static PrescriptionRoute _fromState(GoRouterState state) =>
      const PrescriptionRoute();

  @override
  String get location => GoRouteData.$location('/prescriptions');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LiveDataRoute on GoRouteData {
  static LiveDataRoute _fromState(GoRouterState state) => const LiveDataRoute();

  @override
  String get location => GoRouteData.$location('/livedata');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MVCTestingRoute on GoRouteData {
  static MVCTestingRoute _fromState(GoRouterState state) =>
      const MVCTestingRoute();

  @override
  String get location => GoRouteData.$location('/mvctesting');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ExerciseModeRoute on GoRouteData {
  static ExerciseModeRoute _fromState(GoRouterState state) =>
      const ExerciseModeRoute();

  @override
  String get location => GoRouteData.$location('/exercisemode');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PromptScreenRoute on GoRouteData {
  static PromptScreenRoute _fromState(GoRouterState state) =>
      const PromptScreenRoute();

  @override
  String get location => GoRouteData.$location('/promptscreen');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $UserListRoute on GoRouteData {
  static UserListRoute _fromState(GoRouterState state) => const UserListRoute();

  @override
  String get location => GoRouteData.$location('/userlist');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ExerciseListRoute on GoRouteData {
  static ExerciseListRoute _fromState(GoRouterState state) => ExerciseListRoute(
    userId: int.parse(state.uri.queryParameters['user-id']!),
    title: state.uri.queryParameters['title']!,
  );

  ExerciseListRoute get _self => this as ExerciseListRoute;

  @override
  String get location => GoRouteData.$location(
    '/exerciselist',
    queryParams: {'user-id': _self.userId.toString(), 'title': _self.title},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ExerciseDetailsRoute on GoRouteData {
  static ExerciseDetailsRoute _fromState(GoRouterState state) =>
      ExerciseDetailsRoute(
        userId: int.parse(state.uri.queryParameters['user-id']!),
        exerciseId: int.parse(state.uri.queryParameters['exercise-id']!),
      );

  ExerciseDetailsRoute get _self => this as ExerciseDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/exercisedetail',
    queryParams: {
      'user-id': _self.userId.toString(),
      'exercise-id': _self.exerciseId.toString(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ExerciseDataListRoute on GoRouteData {
  static ExerciseDataListRoute _fromState(GoRouterState state) =>
      ExerciseDataListRoute(
        userId: int.parse(state.uri.queryParameters['user-id']!),
        exerciseId: int.parse(state.uri.queryParameters['exercise-id']!),
      );

  ExerciseDataListRoute get _self => this as ExerciseDataListRoute;

  @override
  String get location => GoRouteData.$location(
    '/exercisedatalist',
    queryParams: {
      'user-id': _self.userId.toString(),
      'exercise-id': _self.exerciseId.toString(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

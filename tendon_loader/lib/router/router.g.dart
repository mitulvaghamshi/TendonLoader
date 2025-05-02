// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$tendonLoaderRoute];

RouteBase get $tendonLoaderRoute => GoRouteData.$route(
  path: '/',
  factory: $TendonLoaderRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'settings',
      factory: $SettingScreenRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'prescriptions',
      factory: $PrescriptionRoute._fromState,
    ),
    GoRouteData.$route(path: 'livedata', factory: $LiveDataRoute._fromState),
    GoRouteData.$route(
      path: 'mvctesting',
      factory: $MVCTestingRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'exercisemode',
      factory: $ExerciseModeRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'promptscreen',
      factory: $PromptScreenRoute._fromState,
    ),
    GoRouteData.$route(path: 'userlist', factory: $UserListRoute._fromState),
    GoRouteData.$route(
      path: 'exerciselist',
      factory: $ExerciseListRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'exercisedetail',
      factory: $ExerciseDetaildRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'exercisedatalist',
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

mixin $ExerciseDetaildRoute on GoRouteData {
  static ExerciseDetaildRoute _fromState(GoRouterState state) =>
      ExerciseDetaildRoute(
        userId: int.parse(state.uri.queryParameters['user-id']!),
        exerciseId: int.parse(state.uri.queryParameters['exercise-id']!),
      );

  ExerciseDetaildRoute get _self => this as ExerciseDetaildRoute;

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

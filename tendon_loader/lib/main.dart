import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/settings/settings.dart';
import 'package:tendon_loader/states/app_scope.dart';
import 'package:tendon_loader/states/app_state.dart';

void main() => runApp(MainApp(state: AppState.empty()));

@immutable
final class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.state});

  final AppState state;

  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: $appRoutes,
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state.service,
      builder: (context, child) => MaterialApp.router(
        title: 'Tendon Loader',
        routerConfig: _router,
        theme: _lightTheme,
        darkTheme: _darkTheme,
        themeMode: state.service.settings.themeMode,
        builder: (_, child) => AppScope(data: state, child: child!),
      ),
    );
  }
}

final _darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorSchemeSeed: Colors.orange,
);

final _lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorSchemeSeed: Colors.green,
);

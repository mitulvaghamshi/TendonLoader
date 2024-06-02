import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/services/settings_service.dart';
import 'package:tendon_loader/services/user_service.dart';
import 'package:tendon_loader/utils/states/app_scope.dart';
import 'package:tendon_loader/utils/states/app_state.dart';

void main() {
  final state = AppState(
    userService: UserService(),
    settingsService: SettingsService(),
  );

  runApp(MainApp(state: state));
}

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
      animation: state,
      builder: (context, child) => MaterialApp.router(
        title: 'Tendon Loader',
        routerConfig: _router,
        theme: _lightTheme,
        darkTheme: _darkTheme,
        themeMode: state.settings.themeMode,
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

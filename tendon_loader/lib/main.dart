import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/states/app_scope.dart';
import 'package:tendon_loader/states/app_state.dart';

void main() => runApp(App(state: AppState()));

@immutable
class App extends StatelessWidget {
  const App({super.key, required this.state});

  final AppState state;

  static final _router = GoRouter(routes: $appRoutes, initialLocation: '/');

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (_, child) {
        return MaterialApp.router(
          title: 'Tendon Loader',
          routerConfig: _router,
          theme: _lightTheme,
          darkTheme: _darkTheme,
          themeMode: state.settings.themeMode,
          builder: (_, child) => AppScope(data: state, child: child!),
        );
      },
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

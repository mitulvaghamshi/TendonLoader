import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/network/api/api_client.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/states/app_scope.dart';
import 'package:tendon_loader/states/app_state.dart';

void main() {
  if (ApiClient.host.isEmpty) {
    throw AssertionError(
      'Fix: Create `.env` file and provide host value using '
      '`API_HOST=<host:port>` environment variable and run your app as: '
      '`flutter run -d macos --dart-define-from-file=.env`',
    );
  }
  runApp(MyApp(state: AppState()));
}

@immutable
class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.state});

  final AppState state;

  static final _router = GoRouter(routes: $appRoutes);

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: state,
    builder: (_, child) => MaterialApp.router(
      title: 'Tendon Loader',
      routerConfig: _router,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: state.settings.darkMode ? .dark : .light,
      builder: (_, child) => AppScope(data: state, child: child!),
    ),
  );
}

final _darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorSchemeSeed: Colors.blueGrey,
);

final _lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorSchemeSeed: Colors.orange,
);

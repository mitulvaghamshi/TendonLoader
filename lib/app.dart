import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/common/router/router.dart';
import 'package:tendon_loader/screens/settings/models/app_scope.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';

class TendonLoader extends StatelessWidget {
  const TendonLoader({super.key, required this.model});

  final AppState model;

  static final GoRouter _router =
      GoRouter(initialLocation: '/', routes: $appRoutes);

  static ThemeData themeData =
      ThemeData(pageTransitionsTheme: _transitionsTheme);

  static ThemeData darkThemeData = ThemeData(
      pageTransitionsTheme: _transitionsTheme, brightness: Brightness.dark);

  static final PageTransitionsTheme _transitionsTheme =
      PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
    defaultTargetPlatform: const _FadePageTransitionsBuilder(),
    TargetPlatform.android: const ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tendon Loader',
      routerConfig: _router,
      theme: themeData,
      darkTheme: darkThemeData,
      themeMode: model.isDarkMode() ? ThemeMode.dark : ThemeMode.light,
      builder: (_, child) => CupertinoTheme(
        data: CupertinoThemeData(
          brightness: model.isDarkMode() ? Brightness.dark : Brightness.light,
        ),
        child: Material(child: AppScope(data: model, child: child!)),
      ),
    );
  }
}

class _FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const _FadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(PageRoute<T>? _, BuildContext? __,
          Animation<double> animation, Animation<double> ___, Widget? child) =>
      FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.ease)),
          child: child);
}

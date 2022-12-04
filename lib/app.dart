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

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Tendon Loader',
      routerConfig: _router,
      theme: themeData,
      darkTheme: darkThemeData,
      themeMode: model.isDarkMode() ? ThemeMode.dark : ThemeMode.light,
      builder: (_, Widget? child) => CupertinoTheme(
        data: CupertinoThemeData(
          brightness: model.isDarkMode() ? Brightness.dark : Brightness.light,
        ),
        child: Material(child: AppScope(data: model, child: child!)),
      ),
    );
  }
}

extension on TendonLoader {
  GoRouter get _router => GoRouter(initialLocation: '/', routes: $appRoutes);

  ThemeData get themeData => ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.green,
      pageTransitionsTheme: _transitionsTheme);

  ThemeData get darkThemeData => ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.lightGreen,
      pageTransitionsTheme: _transitionsTheme,
      brightness: Brightness.dark);

  PageTransitionsTheme get _transitionsTheme =>
      PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
        defaultTargetPlatform: const _FadePageTransitionsBuilder(),
        TargetPlatform.android: const ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
      });
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

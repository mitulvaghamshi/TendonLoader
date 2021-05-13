import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/app/exercise/exercise_mode.dart';
import 'package:tendon_loader/app/exercise/new_exercise.dart';
import 'package:tendon_loader/app/apphome.dart';
import 'package:tendon_loader/app/livedata/live_data.dart';
import 'package:tendon_loader/app/mvctest/mvc_testing.dart';
import 'package:tendon_loader/shared/login/login.dart';
import 'package:tendon_loader/shared/login/splash.dart';
import 'package:tendon_loader/web/webhome.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  Login.home: (_) => kIsWeb ? const WebHome() : const AppHome(),
  Login.route: (_) => const Login(),
  Splash.route: (_) => const Splash(),
  LiveData.route: (_) => const LiveData(),
  MVCTesting.route: (_) => const MVCTesting(),
  NewExercise.route: (_) => const NewExercise(),
  ExerciseMode.route: (_) => const ExerciseMode(),
};

/*
Route<void> getRoute() {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(seconds: 1),
    pageBuilder: (_, Animation<double> animation, Animation<double> secondaryAnimation) => const Home(),
    transitionsBuilder: (_, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        child: child,
        position: animation.drive(
          Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).chain(
            CurveTween(curve: Curves.easeInOutCubic),
          ),
        ),
      );
    },
  );
}
*/

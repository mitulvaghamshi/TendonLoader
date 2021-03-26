import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/bluetooth/debug.dart';
import 'package:tendon_loader/screens/exercise_mode/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise_mode/new_exercise.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/screens/live_data/live_data.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/screens/login/signin.dart';
import 'package:tendon_loader/screens/login/signup.dart';
import 'package:tendon_loader/screens/mvc_testing/mvc_testing.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  Debug.routeName: (_) => const Debug(),
  Login.routeName: (_) => const Login(),
  SignIn.routeName: (_) => const SignIn(),
  SignUp.routeName: (_) => const SignUp(),
  HomePage.routeName: (_) => const HomePage(),
  LiveData.routeName: (_) => const LiveData(),
  MVCTesting.routeName: (_) => const MVCTesting(),
  NewExercise.routeName: (_) => const NewExercise(),
  ExerciseMode.routeName: (_) => const ExerciseMode(),
};

/*Route<void> getRouteByName({String name}) {
  return PageRouteBuilder<void>(
    pageBuilder: (_, Animation<double> animation, Animation<double> secondaryAnimation) => ,
    transitionsBuilder: (_, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        child: child,
        position: animation.drive(Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOutCubic))),
      );
    },
  );
}*/

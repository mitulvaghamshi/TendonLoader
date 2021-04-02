import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/exercise_mode/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise_mode/new_exercise.dart';
import 'package:tendon_loader/screens/home.dart';
import 'package:tendon_loader/screens/live_data/live_data.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/screens/login/signin.dart';
import 'package:tendon_loader/screens/login/signup.dart';
import 'package:tendon_loader/screens/mvc_testing/mvc_testing.dart';
import 'package:tendon_loader/webportal/homepage.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  Home.route: (_) => const Home(),
  Login.route: (_) => const Login(),
  SignUp.route: (_) => const SignUp(),
  SignIn.route: (_) => const SignIn(),
  LiveData.route: (_) => const LiveData(),
  MVCTesting.route: (_) => const MVCTesting(),
  NewExercise.route: (_) => const NewExercise(),
  ExerciseMode.route: (_) => const ExerciseMode(),
  HomePage.route: (_) => const HomePage(),
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

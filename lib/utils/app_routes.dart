import 'package:flutter/widgets.dart';
import 'package:tendon_loader/screens/bluetooth/debug.dart';
import 'package:tendon_loader/screens/exercise_mode/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise_mode/new_exercise.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/screens/live_data/live_data.dart';
import 'package:tendon_loader/screens/login/signin.dart';
import 'package:tendon_loader/screens/login/signup.dart';
import 'package:tendon_loader/screens/mvc_testing/mvc_testing.dart';

final Map<String, WidgetBuilder> routes = {
  Debug.routeName: (_) => Debug(),
  SignIn.routeName: (_) => SignIn(),
  SignUp.routeName: (_) => SignUp(),
  HomePage.routeName: (_) => HomePage(),
  LiveData.routeName: (_) => LiveData(),
  MVCTesting.routeName: (_) => MVCTesting(),
  NewExercise.routeName: (_) => NewExercise(),
  ExerciseMode.routeName: (_) => ExerciseMode(),
};

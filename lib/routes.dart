import 'package:flutter/material.dart' show WidgetBuilder;
import 'package:tendon_loader/home.dart' show Home;
import 'package:tendon_loader/exercise/exercise_mode.dart' show ExerciseMode;
import 'package:tendon_loader/exercise/new_exercise.dart' show NewExercise;
import 'package:tendon_loader/livedata/live_data.dart' show LiveData;
import 'package:tendon_loader/mvctest/mvc_testing.dart' show MVCTesting;
import 'package:tendon_support_module/login/login.dart' show Login;
import 'package:tendon_support_module/login/splash.dart' show Splash;

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  Login.route: (_) => const Login(),
  Splash.route: (_) => const Splash(),
  Home.route: (_) => const Home(),
  LiveData.route: (_) => const LiveData(),
  MVCTesting.route: (_) => const MVCTesting(),
  NewExercise.route: (_) => const NewExercise(),
  ExerciseMode.route: (_) => const ExerciseMode(),
};

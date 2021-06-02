import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/app_settings.dart';
import 'package:tendon_loader/exercise/exercise_mode.dart';
import 'package:tendon_loader/exercise/new_exercise.dart';
import 'package:tendon_loader/home.dart';
import 'package:tendon_loader/livedata/live_data.dart';
import 'package:tendon_loader/mvctest/mvc_testing.dart';
import 'package:tendon_support_module/login/login.dart';
import 'package:tendon_support_module/login/splash.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  Home.route: (_) => const Home(),
  Login.route: (_) => const Login(),
  Splash.route: (_) => const Splash(),
  LiveData.route: (_) => const LiveData(),
  MVCTesting.route: (_) => const MVCTesting(),
  NewExercise.route: (_) => const NewExercise(),
  ExerciseMode.route: (_) => const ExerciseMode(),

  AppSettings.route: (_) => const AppSettings(),
};

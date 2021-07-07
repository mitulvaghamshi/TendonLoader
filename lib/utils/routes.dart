import 'package:flutter/material.dart';
import 'package:tendon_loader/exercise/exercise_mode.dart';
import 'package:tendon_loader/exercise/new_exercise.dart';
import 'package:tendon_loader/homepage.dart';
import 'package:tendon_loader/homescreen.dart';
import 'package:tendon_loader/livedata/live_data.dart';
import 'package:tendon_loader/login/login.dart';
import 'package:tendon_loader/login/splash.dart';
import 'package:tendon_loader/mvctest/mvc_testing.dart';
import 'package:tendon_loader/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/settings/user_settings.dart';

Map<String, WidgetBuilder> get routes => _routes;

final Map<String, WidgetBuilder> _routes = <String, WidgetBuilder>{
  Login.route: (_) => const Login(),
  Splash.route: (_) => const Splash(),
  LiveData.route: (_) => const LiveData(),
  HomePage.route: (_) => const HomePage(),
  HomeScreen.route: (_) => const HomeScreen(),
  NewMVCTest.route: (_) => const NewMVCTest(),
  MVCTesting.route: (_) => const MVCTesting(),
  UserSettings.route: (_) => const UserSettings(),
  NewExercise.route: (_) => const NewExercise(),
  ExerciseMode.route: (_) => const ExerciseMode(),
};

import 'package:flutter/foundation.dart';
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
import 'package:tendon_loader/settings/app_settings.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  Login.homeRoute: (_) => kIsWeb ? const HomePage() : const HomeScreen(),
  Login.route: (_) => const Login(),
  Splash.route: (_) => const Splash(),
  LiveData.route: (_) => const LiveData(),
  NewMVCTest.route: (_) => const NewMVCTest(),
  MVCTesting.route: (_) => const MVCTesting(),
  AppSettings.route: (_) => const AppSettings(),
  NewExercise.route: (_) => const NewExercise(),
  ExerciseMode.route: (_) => const ExerciseMode(),
};

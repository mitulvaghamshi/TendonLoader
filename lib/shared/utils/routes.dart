import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/app/exercise/exercise_mode.dart';
import 'package:tendon_loader/app/exercise/new_exercise.dart';
import 'package:tendon_loader/app/homescreen.dart';
import 'package:tendon_loader/app/livedata/live_data.dart';
import 'package:tendon_loader/app/mvctest/mvc_testing.dart';
import 'package:tendon_loader/app/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/shared/login_screen.dart';
import 'package:tendon_loader/shared/settings_screen.dart';
import 'package:tendon_loader/shared/utils/common.dart';
import 'package:tendon_loader/shared/utils/extension.dart';
import 'package:tendon_loader/web/homepage.dart';

// TODO(mitul): implement deep-link.
/// App made up of 9 different screens, and uses named-route navigation.
final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  LoginScreen.route: (_) => const LoginScreen(),
  HomePage.route: (_) => const HomePage(),
  HomeScreen.route: (_) => const HomeScreen(),
  SettingsScreen.route: (_) => const SettingsScreen(),
  LiveData.route: (_) => const LiveData(),
  NewMVCTest.route: (_) => const NewMVCTest(),
  MVCTesting.route: (_) => const MVCTesting(),
  NewExercise.route: (_) => const NewExercise(),
  ExerciseMode.route: (_) => const ExerciseMode(),
};

/// Build and navigate with slide transition on mobile.
/// This method overrides default navigation transition and
/// adds horizontal sliding effect while transitioning back and forth.
Route<T> buildRoute<T>(String route) {
  return PageRouteBuilder<T>(
    pageBuilder: (BuildContext context, __, ___) => routes[route]!(context),
    transitionsBuilder: (_, Animation<double> animation, ___, Widget child) {
      if (kIsWeb) return child;
      return SlideTransition(
        position: animation.drive(Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.ease))),
        child: child,
      );
    },
  );
}

/// Logout a user from both app and Firebase.
/// Allows app to save any settings or data before logging out user.
/// A [logout] extension method on [BuildContext] class navigates user to the
/// [LoginScreen] screen removing any previous route from the route-history.
Future<void> logout(BuildContext context) async {
  try {
    userState.keepSigned = false;
    await userState.save();
    await settingsState.save();
    await signOut();
  } finally {
    await context.logout();
  }
}

/// Optionally sign out any user from the Firebase Auth.
Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } finally {}
}

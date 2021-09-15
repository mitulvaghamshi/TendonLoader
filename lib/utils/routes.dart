/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/app_settings.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/screens/homescreen.dart';
import 'package:tendon_loader/screens/livedata/live_data.dart';
import 'package:tendon_loader/screens/login.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/screens/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/web/homepage.dart';

/// A full application(+web) made up of 9 different screens, 
/// and uses only named route base navigation between screens.
///
/// below map contains widget builders for each screen used by
/// the [Navigator.pashNamed] method.
///
/// Web portal only depends on the [Login], [HomePage] and [NewExercise] screen.
///
/// All route names must start with a forward slash [/], 
/// this will allow to build URLs for web-based navigation.
final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  Login.route: (_) => const Login(),
  LiveData.route: (_) => const LiveData(),
  HomePage.route: (_) => const HomePage(),
  HomeScreen.route: (_) => const HomeScreen(),
  NewMVCTest.route: (_) => const NewMVCTest(),
  MVCTesting.route: (_) => const MVCTesting(),
  AppSettings.route: (_) => const AppSettings(),
  NewExercise.route: (_) => const NewExercise(),
  ExerciseMode.route: (_) => const ExerciseMode(),
};

/// Build and navigate with slide transition.
///
/// This method overrides default navigation transition and 
/// adds horizontal sliding effect while transitioning back and forth.
///
/// Accepts required route name and returns a generic Route instance,
/// an optional return value type [T] can be supplied in case a widget
/// returns any value.
///
/// All the screens (widgets) contains a static route string 
/// to navigate to. i.e. [Login.route] which is "/login".
Route<T> buildRoute<T>(String routeName, [bool? fullscreen = false]) {
  return PageRouteBuilder<T>(
    fullscreenDialog: fullscreen!,
    pageBuilder: (BuildContext context, __, ___) {
      return routes[routeName]!(context);
    },
    transitionsBuilder: (_, Animation<double> animation, ___, Widget child) {
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
///
/// A convenient method allows app to save any modified 
/// app settings or generated data before logging out any user
///
/// A handy [logout] extension method on [BuildContext] class navigate
/// user to the [Login] screen removing any previous 
/// route from the route-history to prevent backward navigation.
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/screens/homescreen.dart';
import 'package:tendon_loader/screens/livedata/live_data.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/screens/login/splash.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/screens/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/screens/settings/user_settings.dart';
import 'package:tendon_loader/utils/themes.dart';

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

void main() => runApp(const AppStateWidget(child: TendonLoader()));

class TendonLoader extends StatelessWidget {
  const TendonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: _routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      title: 'Tendon Loader',
      initialRoute: Navigator.defaultRouteName,
      builder: (_, Widget? child) => CupertinoTheme(
        data: const CupertinoThemeData(),
        child: Material(child: child),
      ),
    );
  }
}

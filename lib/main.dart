import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/bluetooth/debug.dart';
import 'package:tendon_loader/screens/exercise_mode/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise_mode/new_exercise.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/screens/live_data/live_data.dart';
import 'package:tendon_loader/screens/mvc_testing/mvc_testing.dart';

void main() => runApp(TendonLoader());

// /\*(.|\n)*?\*/
class TendonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tendon Loader',
      theme: ThemeData(
        accentColor: Colors.black,
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (_) => HomePage(),
        LiveData.routeName: (_) => LiveData(),
        NewExercise.routeName: (_) => NewExercise(),
        ExerciseMode.routeName: (_) => ExerciseMode(),
        MVCTesting.routeName: (_) => MVCTesting(),
        Debug.routeName: (_) => Debug(),
      },
    );
  }
}

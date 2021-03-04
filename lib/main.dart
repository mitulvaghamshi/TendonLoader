import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/exercise_mode/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise_mode/new_exercise.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/screens/live_data/live_data.dart';
import 'package:tendon_loader/screens/mvc_testing/mvc_testing.dart';

void main() => runApp(TendonLoader());

class TendonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tendon Loader',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.standard
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (_) => HomePage(),
        LiveData.routeName: (_) => LiveData(),
        NewExercise.routeName: (_) => NewExercise(),
        ExerciseMode.routeName: (_) => ExerciseMode(),
        MVCTesting.routeName: (_) => MVCTesting(),
      },
    );
  }
}

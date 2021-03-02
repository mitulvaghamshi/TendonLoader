import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/exercise_mode.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/screens/live_data.dart';
import 'package:tendon_loader/screens/mvic_testing.dart';
import 'package:tendon_loader/screens/new_exercise.dart';

void main() => runApp(TendonLoader());

class TendonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tendon Loader',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity(horizontal: VisualDensity.maximumDensity, vertical: VisualDensity.maximumDensity),
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (_) => HomePage(),
        LiveData.routeName: (_) => LiveData(),
        NewExercise.routeName: (_) => NewExercise(),
        ExerciseMode.routeName: (_) => ExerciseMode(),
        MVICTesting.routeName: (_) => MVICTesting(),
      },
    );
  }
}

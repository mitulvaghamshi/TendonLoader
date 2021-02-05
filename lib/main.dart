import 'package:flutter/material.dart';

import 'screens/homepage.dart';
import 'screens/exercise_mode.dart';
import 'screens/live_data.dart';
import 'screens/mvic_testing.dart';

void main() => runApp(TendonLoader());

class TendonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tendon Loader',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (_) => HomePage(),
        LiveData.routeName: (_) => LiveData(),
        ExerciseMode.routeName: (_) => ExerciseMode(),
        MVICTesting.routeName: (_) => MVICTesting(),
      },
    );
  }
}

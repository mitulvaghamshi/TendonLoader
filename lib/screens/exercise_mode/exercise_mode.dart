import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/exercise_mode/bar_graph.dart';

class ExerciseMode extends StatelessWidget {
  static const name = 'Exercise Mode';
  static const routeName = '/exerciseMode';

  const ExerciseMode({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(ExerciseMode.name)),
      body: BarGraph(exerciseData: ModalRoute.of(context).settings.arguments),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tendon_loader/components/export_button.dart';
import 'package:tendon_loader/screens/exercise_mode/bar_graph.dart';
import 'package:tendon_loader/utils/create_xlsx.dart';
import 'package:tendon_loader/utils/exercise_data.dart';

class ExerciseMode extends StatelessWidget with CreateXLSX {
  const ExerciseMode({Key/*?*/ key}) : super(key: key);

  static const String name = 'Exercise Mode';
  static const String route = '/exerciseMode';

  @override
  Widget build(BuildContext context) {
    final ExerciseData/*?*/ _data = ModalRoute.of(context)/*!*/.settings.arguments as ExerciseData/*?*/;
    return Scaffold(
      body: BarGraph(exerciseData: _data),
      appBar: AppBar(title: const Text(ExerciseMode.name), actions: <ExportButton>[ExportButton(callback: () => export(exerciseData: _data))]),
    );
  }
}

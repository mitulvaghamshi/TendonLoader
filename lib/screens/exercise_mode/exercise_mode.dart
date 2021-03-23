import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/screens/exercise_mode/bar_graph.dart';
import 'package:tendon_loader/utils/create_xlsx.dart';
import 'package:tendon_loader/utils/exercise_data.dart';

class ExerciseMode extends StatelessWidget with CreateXLSX {
  static const name = 'Exercise Mode';
  static const routeName = '/exerciseMode';

  ExerciseMode({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ExerciseData _data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: BarGraph(exerciseData: _data),
      appBar: AppBar(
        title: const Text(ExerciseMode.name),
        actions: [
          CustomButton(
            text: 'Export Data',
            icon: Icons.backup_rounded,
            onPressed: () => export(exerciseData: _data),
          ),
        ],
      ),
    );
  }
}

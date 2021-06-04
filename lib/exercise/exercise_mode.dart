import 'package:flutter/material.dart';
import 'package:tendon_loader/exercise/bar_graph.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

class ExerciseMode extends StatelessWidget {
  const ExerciseMode({Key? key}) : super(key: key);

  static const String name = 'Exercise Mode';
  static const String route = '/exerciseMode';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(ExerciseMode.name)),
      body: BarGraph(prescription: ModalRoute.of(context)!.settings.arguments! as Prescription),
    );
  }
}

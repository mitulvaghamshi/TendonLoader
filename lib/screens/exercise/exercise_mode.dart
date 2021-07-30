import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/screens/exercise/exercise_handler.dart';
import 'package:tendon_loader/utils/themes.dart';

class ExerciseMode extends StatelessWidget {
  const ExerciseMode({Key? key}) : super(key: key);

  static const String name = 'Exercise Mode';
  static const String route = '/exerciseMode';

  @override
  Widget build(BuildContext context) {
    final ExerciseHandler _handler = ExerciseHandler(context: context);
    return CustomGraph(
      title: name,
      handler: _handler,
      builder: () => Column(children: <Widget>[
        Text(_handler.lapTime, style: _handler.isPush ? tsB40B : tsR40B),
        Text(_handler.counterValue, style: tsB40B),
      ]),
    );
  }
}

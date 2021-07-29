import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
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
      handler: _handler,
      builder: () => Column(children: <Widget>[
        Text(_handler.lapTime, style: _handler.isHold ? tsG40B : tsR40B),
        const SizedBox(height: 10),
        CustomButton(radius: 16, color: _handler.feedColor, right: Text(_handler.counterValue, style: tsB40B)),
      ]),
    );
  }
}

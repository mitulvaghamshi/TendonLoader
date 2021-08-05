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
        Text(_handler.timeCounter, style: _handler.timeStyle),
        const Divider(),
        Row(children: const <Widget>[
          Expanded(child: Text('Rep:', style: TextStyle(color: colorBlack, fontWeight: FontWeight.w500))),
          Expanded(child: Text('Set:', style: TextStyle(color: colorBlack, fontWeight: FontWeight.w500))),
        ]),
        Row(children: <Widget>[
          Expanded(child: Text(_handler.repCounter, textAlign: TextAlign.center, style: tsB40B)),
          Expanded(child: Text(_handler.setCounter, textAlign: TextAlign.center, style: tsB40B)),
        ]),
      ]),
    );
  }
}

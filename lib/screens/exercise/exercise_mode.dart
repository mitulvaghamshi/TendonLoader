/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/graph/custom_graph.dart';
import 'package:tendon_loader/screens/graph/graph_handler.dart';
import 'package:tendon_loader/screens/exercise/exercise_handler.dart';
import 'package:tendon_loader/utils/themes.dart';

class ExerciseMode extends StatefulWidget {
  const ExerciseMode({Key? key}) : super(key: key);

  static const String name = 'Exercise Mode';
  static const String route = '/exerciseMode';

  @override
  _ExerciseModeState createState() => _ExerciseModeState();
}

class _ExerciseModeState extends State<ExerciseMode>
    with WidgetsBindingObserver {
  late final ExerciseHandler _handler = ExerciseHandler(context: context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (AppLifecycleState.paused == state) {
      _handler.pause();
      Future<void>.delayed(const Duration(minutes: 10), () {
        if (isPause) _handler.stop();
      });
    } else if (AppLifecycleState.resumed == state) {
      if (_handler.isRunning) _handler.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomGraph(
      handler: _handler,
      title: ExerciseMode.name,
      builder: () => Column(children: <Widget>[
        Text(_handler.timeCounter, style: _handler.timeStyle),
        const Divider(),
        Row(children: const <Widget>[
          Expanded(child: Text('Rep:', style: tsBW500)),
          Expanded(child: Text('Set:', style: tsBW500)),
        ]),
        Row(children: <Widget>[
          Expanded(
            child: Text(
              _handler.repCounter,
              textAlign: TextAlign.center,
              style: tsB40B,
            ),
          ),
          Expanded(
            child: Text(
              _handler.setCounter,
              textAlign: TextAlign.center,
              style: tsB40B,
            ),
          ),
        ]),
      ]),
    );
  }
}

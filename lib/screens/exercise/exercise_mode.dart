/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

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

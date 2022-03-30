import 'package:flutter/material.dart';
import 'package:tendon_loader/app/exercise/exercise_handler.dart';
import 'package:tendon_loader/app/graph/graph_handler.dart';
import 'package:tendon_loader/app/graph/graph_widget.dart';

const TextStyle _headerStyle =
    TextStyle(color: Color(0xff000000), fontWeight: FontWeight.w500);

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

  /// The execution of 10 minutes never tested on real device!
  /// Different OS's has different policy for background tasks.
  /// There is no guarantee to keep app alive in background for
  /// 10 minutes, process might be killed and recreated by the system.
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
    return GraphWidget(
      handler: _handler,
      title: ExerciseMode.name,
      builder: () => Column(children: <Widget>[
        Text(_handler.timeCounter, style: _handler.timeStyle),
        const Divider(),
        Row(children: const <Widget>[
          Expanded(child: Text('Rep:', style: _headerStyle)),
          Expanded(child: Text('Set:', style: _headerStyle)),
        ]),
        Row(children: <Widget>[
          Expanded(
            child: Text(
              _handler.repCounter,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                color: Color(0xff000000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              _handler.setCounter,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                color: Color(0xff000000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}

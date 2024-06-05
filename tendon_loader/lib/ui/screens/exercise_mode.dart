import 'package:flutter/material.dart';
import 'package:tendon_loader/handlers/exercise_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/ui/widgets/graph_widget.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class ExerciseMode extends StatefulWidget {
  const ExerciseMode({super.key, required this.handler});

  final ExerciseHandler handler;

  static const String name = 'Exercise Mode';

  @override
  ExerciseModeState createState() => ExerciseModeState();
}

class ExerciseModeState extends State<ExerciseMode>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (AppLifecycleState.paused == state) {
      widget.handler.pause();
      Future<void>.delayed(const Duration(minutes: 1), () {
        if (isPause) widget.handler.stop();
      });
    } else if (AppLifecycleState.resumed == state) {
      if (widget.handler.isRunning) widget.handler.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GraphWidget(
      onExit: (key) {
        const PromptScreenRoute().go(context);
        return true;
      },
      handler: widget.handler,
      title: ExerciseMode.name,
      builder: () => Column(children: [
        Text(widget.handler.timeCounter, style: widget.handler.timeStyle),
        const Divider(),
        const Row(children: [
          Expanded(child: Text('Rep:', style: Styles.headerLabel)),
          Expanded(child: Text('Set:', style: Styles.headerLabel)),
        ]),
        Row(children: [
          Expanded(
            child: Text(
              widget.handler.repCounter,
              textAlign: TextAlign.center,
              style: Styles.headerText,
            ),
          ),
          Expanded(
            child: Text(
              widget.handler.setCounter,
              textAlign: TextAlign.center,
              style: Styles.headerText,
            ),
          ),
        ]),
      ]),
    );
  }
}

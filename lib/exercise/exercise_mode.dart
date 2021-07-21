import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/textstyles.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/exercise/exercise_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';

class ExerciseMode extends StatefulWidget {
  const ExerciseMode({Key? key}) : super(key: key);

  static const String name = 'Exercise Mode';
  static const String route = '/exerciseMode';

  @override
  _ExerciseModeState createState() => _ExerciseModeState();
}

class _ExerciseModeState extends State<ExerciseMode> {
  late final ExerciseHandler _handler = ExerciseHandler(context: context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(ExerciseMode.name)),
      body: CustomGraph(
        handler: _handler,
        header: StreamBuilder<ChartData>(
          initialData: ChartData(),
          stream: GraphHandler.stream,
          builder: (_, AsyncSnapshot<ChartData> snapshot) {
            _handler.graphData.insert(0, snapshot.data!);
            _handler.graphCtrl?.updateDataSource(updatedDataIndex: 0);
            return FittedBox(
              child: Column(children: <Widget>[
                Text(_handler.lapTime, style: _handler.isHold ? tsG40B : tsR40B),
                const SizedBox(height: 20),
                Chip(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: _handler.feedColor,
                  label: Text(_handler.counterValue, style: tsB40B),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}

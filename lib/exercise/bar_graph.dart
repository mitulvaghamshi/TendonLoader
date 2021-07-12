import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_controls.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/device/handler/device_handler.dart';
import 'package:tendon_loader/exercise/progress_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/utils/themes.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  late final ExerciseHandler _handler = ExerciseHandler(context: context);

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onExit: _handler.exit,
      child: Column(children: <Widget>[
        StreamBuilder<ChartData>(
          stream: graphDataStream..listen((ChartData data) => _handler.update(data.time.truncate())),
          initialData: ChartData(),
          builder: (_, AsyncSnapshot<ChartData> snapshot) {
            _handler.graphData.insert(0, snapshot.data!);
            _handler.graphCtrl?.updateDataSource(updatedDataIndex: 0);
            return FittedBox(
              fit: BoxFit.fitWidth,
              child: Column(children: <Widget>[
                Text(
                  _handler.lapTime,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: _handler.isHold ? colorGoogleGreen : colorRed400,
                  ),
                ),
                const SizedBox(height: 10),
                Chip(
                  padding: const EdgeInsets.all(16),
                  label: Text(
                    _handler.progress,
                    style: const TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: snapshot.data!.load > _handler.pre.targetLoad ? colorGoogleGreen : colorGoogleYellow,
                ),
              ]),
            );
          },
        ),
        CustomGraph(handler: _handler),
        GraphControls(stop: _handler.stop, start: _handler.start, reset: _handler.reset),
      ]),
    );
  }
}

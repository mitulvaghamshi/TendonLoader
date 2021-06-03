import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' show ChartSeriesController;
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart'
    show exportDataList, startWeightMeasuring, stopWeightMeasuring;
import 'package:tendon_loader/handler/clip_player.dart';
import 'package:tendon_loader/handler/data_handler.dart' show graphDataStream;
import 'package:tendon_support_lib/tendon_support_lib.dart'
    show AppFrame, CountDown, GraphControls, ExTimeFormat, ChartData;

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  final List<ChartData?> _graphData = <ChartData?>[];

  ChartSeriesController? _graphCtrl;
  bool _isRunning = false;

  Future<void> _start() async {
    if (!_isRunning && (_isRunning = await CountDown.start(context) ?? false)) {
      await startWeightMeasuring();
      play(Clip.start);
    }
  }

  void _reset() {
    if (_isRunning) {
      _isRunning = false;
      play(Clip.stop);
      stopWeightMeasuring();
      exportDataList.clear();
    }
  }

  @override
  void dispose() {
    _reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: Column(
        children: <Widget>[
          StreamBuilder<ChartData>(
            initialData: const ChartData(),
            stream: graphDataStream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              _graphData.insert(0, snapshot.data);
              _graphCtrl?.updateDataSource(updatedDataIndex: 0);
              return FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  snapshot.data!.time!.toTime,
                  style: const TextStyle(color: Colors.green, fontSize: 40, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          CustomGraph(graphData: _graphData, graphCtrl: (ChartSeriesController ctrl) => _graphCtrl = ctrl),
          GraphControls(start: _start, reset: _reset),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/custom/custom_controls.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/device/handler/device_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/utils/clip_player.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/helper.dart';
import 'package:tendon_loader/utils/themes.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  final List<ChartData> _graphData = <ChartData>[];
  ChartSeriesController? _graphCtrl;
  bool _isRunning = false;

  Future<void> _start() async {
    if (!_isRunning && (_isRunning = await startCountdown(context) ?? false)) {
      play(true);
      await startWeightMeas();
    }
  }

  Future<void> _reset() async {
    if (_isRunning) {
      _isRunning = false;
      play(false);
      await stopWeightMeas();
      exportDataList.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onExit: () => _reset().then((_) => true),
      child: Column(
        children: <Widget>[
          StreamBuilder<ChartData>(
            initialData: ChartData(),
            stream: graphDataStream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              _graphData.insert(0, snapshot.data!);
              _graphCtrl?.updateDataSource(updatedDataIndex: 0);
              return FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  snapshot.data!.time!.toTime,
                  style: const TextStyle(color: colorGoogleGreen, fontSize: 40, fontWeight: FontWeight.bold),
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

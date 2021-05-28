import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' show ChartSeriesController;
import 'package:tendon_loader/custom/custom_graph.dart' show CustomGraph;
import 'package:tendon_loader/handler/bluetooth_handler.dart' show Bluetooth;
import 'package:tendon_loader/handler/data_handler.dart' show DataHandler;
import 'package:tendon_support_lib/tendon_support_lib.dart'
    show AppFrame, ClipPlayer, CountDown, GraphControls, ExTimeFormat;
import 'package:tendon_support_module/modal/chartdata.dart' show ChartData;

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> with DataHandler {
  final List<ChartData?> _graphData = <ChartData?>[];

  ChartSeriesController? _graphCtrl;
  bool _isRunning = false;

  Future<void> _start() async {
    if (!_isRunning && (_isRunning = await CountDown.start(context) ?? false)) {
      await Bluetooth.startWeightMeas();
      ClipPlayer.playStart();
    }
  }

  void _reset() {
    if (_isRunning) {
      _isRunning = false;
      ClipPlayer.playStop();
      Bluetooth.stopWeightMeas();
      Bluetooth.dataList.clear();
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
            stream: dataStream,
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

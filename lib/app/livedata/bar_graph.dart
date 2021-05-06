import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/app/custom/countdown.dart';
import 'package:tendon_loader/app/custom/custom_controls.dart';
import 'package:tendon_loader/app/custom/custom_graph.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/app/handler/export_handler.dart';
import 'package:tendon_loader/shared/common.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/extensions.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/data_handler.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  double _lastMilliSec = 0;
  bool _isRunning = false;
  ChartSeriesController _graphDataCtrl;
  final List<ChartData> _graphData = <ChartData>[ChartData()];
  final DataHandler _handler = DataHandler();

  Future<void> _start() async {
    if (!_isRunning && (await CountDown.start(context) ?? false)) {
      _isRunning = true;
      await Bluetooth.startWeightMeas();
    }
  }

  Future<void> _reset() async {
    if (_isRunning) {
      _isRunning = false;
      await Bluetooth.stopWeightMeas();
      _handler.sink.add(ChartData());
      _graphData.insert(0, ChartData());
      _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
      _lastMilliSec = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    Bluetooth.listen(_listener);
  }

  @override
  void dispose() {
    _reset();
    _handler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<ChartData>(
            initialData: ChartData(),
            stream: _handler.stream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) => Text(
              snapshot.data.time.formatTime,
              style: tsBold26.copyWith(color: Colors.green),
            ),
          ),
          const SizedBox(height: 20),
          CustomGraph(isLive: true, series: _getSeries),
          const SizedBox(height: 30),
          GraphControls(start: _start, reset: _reset),
        ],
      ),
    );
  }

  List<ChartSeries<ChartData, int>> _getSeries() {
    return <ChartSeries<ChartData, int>>[
      ColumnSeries<ChartData, int>(
        width: 0.9,
        borderWidth: 1,
        color: Colors.blue,
        animationDuration: 0,
        dataSource: _graphData,
        borderColor: Colors.black,
        xValueMapper: (ChartData data, _) => 1,
        yValueMapper: (ChartData data, _) => data.load,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          showZeroValue: false,
          labelAlignment: ChartDataLabelAlignment.bottom,
          textStyle: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
        ),
        onRendererCreated: (ChartSeriesController controller) => _graphDataCtrl = controller,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
    ];
  }

  void _listener(List<int> data) {
    if (_isRunning && data.isNotEmpty && data[0] == Progressor.RES_WEIGHT_MEAS) {
      for (int x = 2; x < data.length; x += 8) {
        final double weight = data.getRange(x, x + 4).toList().toWeight;
        final double time = data.getRange(x + 4, x + 8).toList().toTime;
        if (time > _lastMilliSec) {
          _lastMilliSec = time;
          final ChartData element = ChartData(load: weight, time: time);
          ExportHandler.dataList.add(element);
          _handler.sink.add(element);
          _graphData.insert(0, element);
          _graphDataCtrl?.updateDataSource(updatedDataIndex: 0);
        }
      }
    }
  }
}

/*
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/utils/app/constants.dart';
import 'package:tendon_loader/utils/controller/bluetooth.dart';
import 'package:tendon_loader/utils/modal/chart_data.dart';

class DataHandler {
  DataHandler({this.targetLoad, this.isMVC = false}) {
    if (targetLoad != null) _lineData = <ChartData>[ChartData(x: 0, load: targetLoad), ChartData(x: 2, load: targetLoad)];
    Bluetooth.startNotify();
    Bluetooth.listen(_listener);
  }

  final StreamController<double> _weightCtrl = StreamController<double>();
  final StreamController<int> _timeCtrl = StreamController<int>();
  final List<ChartData> _graphData = <ChartData>[const ChartData(load: 0)];
  final Stopwatch _stopwatch = Stopwatch();
  final bool isMVC;
  ChartSeriesController _graphDataCtrl;
  ChartSeriesController _lineDataCtrl;
  List<ChartData> _lineData;
  double targetLoad;
  Timer _timer;

  Stream<int> get timeStream => _timeCtrl.stream;

  StreamSink<int> get timeSink => _timeCtrl.sink;

  Stream<double> get weightStream => _weightCtrl.stream;

  StreamSink<double> get weightSink => _weightCtrl.sink;

  Future<void> stop() async {
    if (_timer?.isActive ?? false) _timer.cancel();
    if (isMVC) await Bluetooth.stopWeightMeas();
  }

  Future<void> start() async {
    _stopwatch.start();
    if (!(_timer?.isActive ?? false)) {
      await Bluetooth.startWeightMeas();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => timeSink.add(_stopwatch.elapsedMilliseconds ~/ 1000));
    }
  }

  Future<void> reset() async {
    await Bluetooth.stopWeightMeas();
    if (_timer != null && _timer.isActive) _timer.cancel();
    _stopwatch.reset();
    await timeSink.close();
    await weightSink.close();
    _graphData.insert(0, const ChartData(load: 0));
    _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
    if (isMVC) {
      _lineData.insertAll(0, <ChartData>[const ChartData(x: 0, load: 0), const ChartData(x: 2, load: 0)]);
      _lineDataCtrl.updateDataSource(updatedDataIndexes: <int>[0, 1]);
    }
  }

  Future<void> dispose() async {
    await reset();
    await Bluetooth.stopNotify();
    if (!_timeCtrl.isClosed) await _timeCtrl.close();
    if (!_weightCtrl.isClosed) await _weightCtrl.close();
  }

  void _listener(List<int> _data) {
    int _counter = 0;
    int _time = 0;
    double _avgTime = 0;
    double _timeSum = 0;
    double _weight = 0;
    double _avgWeight = 0;
    double _weightSum = 0;
    if (_data.isNotEmpty && _data[0] == Progressor.RES_WEIGHT_MEAS) {
      for (int x = 2; x < _data.length; x += 8) {
        _weightSum +=
_weight =
 Uint8List.fromList(_data.getRange(x, x + 4).toList()).buffer.asByteData().getFloat32(0, Endian.little);
        _timeSum +=
_time =
 Uint8List.fromList(_data.getRange(x + 4, x + 8).toList()).buffer.asByteData().getUint32(0, Endian.little);
        if (_counter++ == 8) {
          _avgWeight = double.parse((_weightSum.abs() / 8.0).toStringAsFixed(2));
          _avgTime = double.parse(((_timeSum / 8.0) / 1000000.0).toStringAsFixed(2));
          _graphData.insert(0, ChartData(load: _avgWeight));
          _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
          if (isMVC && _avgWeight >= targetLoad) {
            targetLoad = _avgWeight;
            _lineData.insertAll(0, <ChartData>[ChartData(x: 0, load: targetLoad), ChartData(x: 2, load: targetLoad)]);
            _lineDataCtrl.updateDataSource(updatedDataIndexes: <int>[0, 1]);
          }
          if (!_weightCtrl.isClosed) _weightCtrl.add(isMVC ? targetLoad : _avgWeight);
          _weightSum = 0;
          _timeSum = 0;
          _counter = 0;
        }
      }
    }
  }

  List<ChartSeries<ChartData, int>> getSeries() {
    final List<ChartSeries<ChartData, int>> components = <ChartSeries<ChartData, int>>[
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
          textStyle: const TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
        ),
        onRendererCreated: (ChartSeriesController controller) => _graphDataCtrl = controller,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
    ];
    if (_lineData != null) {
      components.add(LineSeries<ChartData, int>(
        width: 5,
        color: Colors.red,
        animationDuration: 0,
        dataSource: _lineData,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.load,
        onRendererCreated: (ChartSeriesController controller) => _lineDataCtrl = controller,
      ));
    }
    return components;
  }
}
*/

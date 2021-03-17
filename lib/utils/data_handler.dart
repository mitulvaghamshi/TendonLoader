import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/utils/bluetooth.dart';
import 'package:tendon_loader/utils/chart_data.dart';
import 'package:tendon_loader/utils/create_xlsx.dart';
import 'package:tendon_loader/utils/exercise_data.dart';

class DataHandler {
  final StreamController<double> _weightCtrl = StreamController<double>();
  final StreamController<int> _timeCtrl = StreamController<int>();
  final List<ChartData> _graphData = [const ChartData(weight: 0)];
  final Stopwatch _stopwatch = Stopwatch();
  ChartSeriesController _graphDataCtrl;
  final List<ChartData> lineData;
  CreateXLSX _xlsx;
  Timer _timer;

  Stream<int> get timeStream => _timeCtrl.stream;

  StreamSink<int> get timeSink => _timeCtrl.sink;

  Stream<double> get weightStream => _weightCtrl.stream;

  StreamSink<double> get weightSink => _weightCtrl.sink;

  DataHandler({this.lineData, ExerciseData exerciseData}) {
    Bluetooth.instance.startNotify();
    Bluetooth.instance.listen(valueListener);
    _xlsx = CreateXLSX(isExercise: lineData != null, exerciseData: exerciseData);
  }

  void init() {
    _xlsx.init();
    _xlsx.fillInfo();
  }

  void stop() {
    if (_timer?.isActive ?? false) _timer.cancel();
  }

  Future start() async {
    _stopwatch.start();
    if (!(_timer?.isActive ?? false)) {
      await Bluetooth.instance.startWeightMeas();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        timeSink.add(_stopwatch.elapsedMilliseconds ~/ 1000);
      });
    }
  }

  Future reset() async {
    stop();
    _stopwatch.reset();
    timeSink.add(0);
    weightSink.add(0);
    await Bluetooth.instance.stopWeightMeas();
    _graphData.insert(0, const ChartData(weight: 0));
    _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
    await _xlsx.save();
  }

  Future dispose() async {
    await reset();
    await Bluetooth.instance.stopNotify();
    if (_timeCtrl.isClosed) _timeCtrl.close();
    if (_weightCtrl.isClosed) _weightCtrl.close();
  }

  void valueListener(List<int> _data) {
    int _counter = 0, _time = 0, _timeSum = 0;
    double _avgTime = 0, _weight = 0, _avgWeight = 0, _weightSum = 0;
    if (_data.isNotEmpty && _data[0] == Bluetooth.RES_WEIGHT_MEAS) {
      for (int x = 2; x < _data.length; x += 8) {
        _weightSum += _weight =
            Uint8List.fromList(_data.getRange(x, x + 4).toList()).buffer.asByteData().getFloat32(0, Endian.little);
        _timeSum += _time =
            Uint8List.fromList(_data.getRange(x + 4, x + 8).toList()).buffer.asByteData().getUint32(0, Endian.little);
        _xlsx.add(ChartData(weight: _weight, time: _time));
        if (_counter++ == 8) {
          _avgTime = double.parse(((_timeSum / 8) / 1000000.0).toStringAsFixed(2));
          _avgWeight = double.parse((_weightSum.abs() / 8.0).toStringAsFixed(2));
          _graphData.insert(0, ChartData(weight: _avgWeight));
          _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
          if (!_weightCtrl.isClosed) _weightCtrl.add(_avgWeight);
          _counter = 0;
          _timeSum = 0;
          _weightSum = 0;
        }
      }
    }
  }

  List<ChartSeries<ChartData, int>> getSeries() {
    List<ChartSeries<ChartData, int>> components = [
      ColumnSeries<ChartData, int>(
        width: 0.9,
        animationDuration: 0,
        dataSource: _graphData,
        xValueMapper: (data, _) => 1,
        yValueMapper: (data, _) => data.weight,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          showZeroValue: false,
          labelAlignment: ChartDataLabelAlignment.bottom,
          textStyle: const TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
        ),
        gradient: const LinearGradient(
          stops: const [0.4, 1],
          end: Alignment.topCenter,
          begin: Alignment.bottomCenter,
          colors: const [Colors.blue, Colors.lightGreenAccent],
        ),
        onRendererCreated: (controller) => _graphDataCtrl = controller,
        borderRadius: const BorderRadius.only(topLeft: const Radius.circular(20), topRight: const Radius.circular(20)),
      ),
    ];
    if (lineData != null)
      components.add(LineSeries<ChartData, int>(
        width: 5,
        color: Colors.red,
        animationDuration: 0,
        dataSource: lineData,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.weight,
      ));
    return components;
  }
}

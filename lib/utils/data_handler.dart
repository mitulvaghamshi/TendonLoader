import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/utils/bluetooth.dart';
import 'package:tendon_loader/utils/chart_data.dart';
import 'package:tendon_loader/utils/create_xlsx.dart';

class DataHandler {
  final StreamController<int> _timeCtrl = StreamController<int>();
  final StreamController<double> _weightCtrl = StreamController<double>();
  final List<ChartData> _graphData = [const ChartData(weight: 0)];
  final List<ChartData> measurements = [];
  final List<ChartData> lineData;
  final Stopwatch _stopwatch = Stopwatch();
  ChartSeriesController _graphDataCtrl;
  Timer _timer;

  Stream<int> get timeStream => _timeCtrl.stream;

  StreamSink<int> get timeSink => _timeCtrl.sink;

  Stream<double> get weightStream => _weightCtrl.stream;

  StreamSink<double> get weightSink => _weightCtrl.sink;

  DataHandler({this.lineData}) {
    Bluetooth.instance.startNotify();
    Bluetooth.instance.listen(valueListener);
  }

  Future init() async => await Bluetooth.instance.startWeightMeas();

  Future start() async {
    _stopwatch.start();
    if (!(_timer?.isActive ?? false)) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => timeSink.add(_stopwatch.elapsedMilliseconds ~/ 1000),
      );
    }
  }

  void addSeparator(String msg) {
    measurements.add();
  }

  void stop() async {
    // _stopwatch.stop();
    if (_timer?.isActive ?? false) _timer.cancel();
  }

  Future reset() async {
    stop();
    _stopwatch.reset();
    timeSink.add(0);
    weightSink.add(0);
    await Bluetooth.instance.stopWeightMeas();
    _graphData.insert(0, const ChartData(weight: 0));
    _graphDataCtrl.updateDataSource(updatedDataIndex: 0);

    CreateXLSX _create = CreateXLSX(measurements: measurements);
    await _create.generateExcel();
  }

  Future dispose() async {
    await reset();
    await Bluetooth.instance.stopNotify();
    if (_timeCtrl.isClosed) _timeCtrl.close();
    if (_weightCtrl.isClosed) _weightCtrl.close();
  }

  void valueListener(List<int> dataList) {
    int _counter = 0;
    int _averageTime = 0;
    double _averageWeight = 0;
    if (dataList.isNotEmpty && dataList[0] == Bluetooth.RES_WEIGHT_MEAS) {
      for (int x = 2; x < dataList.length; x += 8) {
        _averageWeight +=
            Uint8List.fromList(dataList.getRange(x, x + 4).toList()).buffer.asByteData().getFloat32(0, Endian.little);
        _averageTime += Uint8List.fromList(dataList.getRange(x + 4, x + 8).toList())
            .buffer
            .asByteData()
            .getUint32(0, Endian.little);
        if (_counter++ == 8) {
          double _weight = double.parse((_averageWeight.abs() / 8.0).toStringAsFixed(2));
          double _time = double.parse(((_averageTime / 8) / 1000000.0).toStringAsFixed(2));
          measurements.add(ChartData(weight: _weight, time: _time));
          if (!_weightCtrl.isClosed) _weightCtrl.add(_weight);
          _graphData.insert(0, ChartData(weight: _weight));
          _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
          _counter = 0;
          _averageTime = 0;
          _averageWeight = 0;
        }
      }
    }
  }

  List<ChartSeries<ChartData, int>> getSeries() {
    List<ChartSeries<ChartData, int>> components = [
      ColumnSeries<ChartData, int>(
        width: 0.9,
        color: Colors.blue,
        dataSource: _graphData,
        animationDuration: 0,
        xValueMapper: (data, _) => 1,
        yValueMapper: (data, _) => data.weight,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          showZeroValue: false,
          labelAlignment: ChartDataLabelAlignment.bottom,
          textStyle: const TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
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

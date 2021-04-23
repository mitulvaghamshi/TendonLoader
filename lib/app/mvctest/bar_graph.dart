import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/app/custom/countdown.dart';
import 'package:tendon_loader/app/custom/custom_controls.dart';
import 'package:tendon_loader/app/custom/custom_graph.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/app/handler/export_handler.dart';
import 'package:tendon_loader/shared/common.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  final DataHandler _handler = DataHandler();
  bool _isRunning = false;
  bool _isComplete = false;
  DateTime _dateTime;

  String _mvcValue(double weight) => 'MVC: ${weight.toStringAsFixed(2).padLeft(2, '0')} Kg';

  Future<void> _start() async {
    if (!_isRunning && (await CountDown.start(context) ?? false)) {
      _isRunning = true;
      await _handler.start();
      _dateTime = DateTime.now();
    }
  }

  Future<void> _reset() async {
    if (_isRunning) {
      _isRunning = false;
      await _handler.reset();
      await ExportHandler.export(
        _handler.dataList,
        sessionInfo: SessionInfo(
          dateTime: _dateTime,
          dataStatus: _isComplete,
          exportType: Keys.KEY_PREFIX_MVC,
          userId: (await Hive.openBox<Object>(Keys.KEY_LOGIN_BOX)).get(Keys.KEY_USERNAME) as String,
        ),
      );
    }
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
        children: <Widget>[
          StreamBuilder<double>(
            initialData: 0,
            stream: _handler.weightStream,
            builder: (_, AsyncSnapshot<double> snapshot) => Text(_mvcValue(snapshot.data), style: textStyleBold26),
          ),
          const SizedBox(height: 20),
          StreamBuilder<int>(
            initialData: 0,
            stream: _handler.timeStream,
            builder: (_, AsyncSnapshot<int> snapshot) {
              if (5 - snapshot.data == 0) {
                _handler.stop();
                _isComplete = true;
              }
              return Text('Time remaining : ${5 - snapshot.data} s', style: textStyleBold26.copyWith(color: Colors.deepOrange));
            },
          ),
          const SizedBox(height: 20),
          CustomGraph(series: _handler.getSeries),
          const SizedBox(height: 30),
          GraphControls(start: _start, reset: _reset),
        ],
      ),
    );
  }
}

class DataHandler {
  DataHandler() {
    Bluetooth.listen(_listener);
  }

  Timer _timer;
  double targetLoad = 0;
  ChartSeriesController _graphDataCtrl;
  ChartSeriesController _lineDataCtrl;
  final List<ChartData> dataList = <ChartData>[];
  final StreamController<int> _timeCtrl = StreamController<int>();
  final StreamController<double> _weightCtrl = StreamController<double>();
  final List<ChartData> _graphData = <ChartData>[ChartData()];
  final List<ChartData> _lineData = <ChartData>[ChartData(), ChartData(time: 2)];

  Stream<int> get timeStream => _timeCtrl.stream;

  Stream<double> get weightStream => _weightCtrl.stream;

  Future<void> start() async {
    if (_timer == null) {
      await Bluetooth.startWeightMeas();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _timeCtrl.sink.add(_timer.tick));
    }
  }

  Future<void> stop() async {
    if (_timer != null) {
      await Bluetooth.stopWeightMeas();
      _timer.cancel();
      _timer = null;
    }
  }

  Future<void> reset() async {
    await stop();
    targetLoad = 0;
    if (!_timeCtrl.isClosed) _timeCtrl.sink.add(0);
    if (!_weightCtrl.isClosed) _weightCtrl.sink.add(0);
    _graphData.insert(0, ChartData());
    _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
    _lineData.insertAll(0, <ChartData>[ChartData(), ChartData(time: 2)]);
    _lineDataCtrl.updateDataSource(updatedDataIndexes: <int>[0, 1]);
  }

  Future<void> dispose() async {
    if (!_timeCtrl.isClosed) await _timeCtrl.close();
    if (!_weightCtrl.isClosed) await _weightCtrl.close();
  }

  void _listener(List<int> _data) {
    int _counter = 0;
    double _avgTime = 0;
    double _avgWeight = 0;
    double _timeSum = 0;
    double _weightSum = 0;

    if (_data.isNotEmpty && _data[0] == Progressor.RES_WEIGHT_MEAS) {
      for (int x = 2; x < _data.length; x += 8) {
        _weightSum += Uint8List.fromList(_data.getRange(x, x + 4).toList()).buffer.asByteData().getFloat32(0, Endian.little);
        _timeSum += Uint8List.fromList(_data.getRange(x + 4, x + 8).toList()).buffer.asByteData().getUint32(0, Endian.little);
        if (_counter++ == 8) {
          _avgWeight = double.parse((_weightSum.abs() / 8.0).toStringAsFixed(2));
          _avgTime = double.parse(((_timeSum / 8.0) / 1000000.0).toStringAsFixed(2));
          dataList.add(ChartData(time: _avgTime, load: _avgWeight));
          _graphData.insert(0, ChartData(load: _avgWeight));
          _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
          if (!_weightCtrl.isClosed) _weightCtrl.sink.add(targetLoad);
          if (_avgWeight >= targetLoad) {
            targetLoad = _avgWeight;
            _lineData.insertAll(0, <ChartData>[ChartData(load: targetLoad), ChartData(time: 2, load: targetLoad)]);
            _lineDataCtrl.updateDataSource(updatedDataIndexes: <int>[0, 1]);
          }
          _weightSum = 0;
          _timeSum = 0;
          _counter = 0;
        }
      }
    }
  }

  List<ChartSeries<ChartData, int>> getSeries() {
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
          textStyle: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
        ),
        onRendererCreated: (ChartSeriesController controller) => _graphDataCtrl = controller,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      LineSeries<ChartData, int>(
        width: 5,
        color: Colors.red,
        animationDuration: 0,
        dataSource: _lineData,
        yValueMapper: (ChartData data, _) => data.load,
        xValueMapper: (ChartData data, _) => data.time.toInt(),
        onRendererCreated: (ChartSeriesController controller) => _lineDataCtrl = controller,
      ),
    ];
  }
}

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/components/app_frame.dart';
import 'package:tendon_loader/components/countdown.dart';
import 'package:tendon_loader/components/custom_graph.dart';
import 'package:tendon_loader/components/graph_controls.dart';
import 'package:tendon_loader/utils/app/constants.dart';
import 'package:tendon_loader/utils/controller/bluetooth.dart';
import 'package:tendon_loader/utils/controller/create_excel.dart';
import 'package:tendon_loader/utils/modal/chart_data.dart';
import 'package:tendon_loader/utils/modal/exercise_data.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key, @required this.data}) : super(key: key);

  final ExerciseData data;

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> with CreateExcel {
  int _holdTime = 0;
  int _restTime = 0;
  int _currentSet = 1;
  int _currentRep = 1;
  double _targetLoad = 0;
  bool _isHold = true;
  bool _isRunning = false;
  DataHandler _handler;
  ExerciseData _exerciseData;

  void _update() {
    if (_holdTime == 0) {
      _isHold = false;
      _holdTime = _exerciseData.holdTime;
    }
    if (_restTime == 0) {
      _isHold = true;
      _restTime = _exerciseData.restTime;
      if (_currentRep == _exerciseData.reps) {
        if (_currentSet == _exerciseData.sets) {
          _reset();
        } else {
          _rest();
          _currentSet++;
          _currentRep = 1;
        }
      } else {
        _currentRep++;
      }
    }
  }

  Future<void> _reset() async {
    if (_isRunning) {
      _isHold = true;
      _isRunning = false;
      _currentRep = _currentSet = 1;
      _holdTime = _exerciseData.holdTime;
      _restTime = _exerciseData.restTime;
      await _handler.reset();

      // final Map<String, dynamic> _map = <String, dynamic>{};
      // _map[Keys.keyIsComplete] = true;
      // _map[Keys.keyProgressorId] = Bluetooth.deviceName;
      // _map[Keys.keyExportData] = _handler.dataList.map((ChartData data) => data.toMap()).toList();
      // _map[Keys.keyExerciseInfo] = widget.data.toMap();
      // await DataStorage.save(_handler.dataList, 'file0001');
      // await await create(exerciseData: widget.data, data: _handler.dataList);
    }
  }

  Future<void> _rest() async {
    await _handler.stop();
    final bool result = await CountDown.start(context, duration: const Duration(seconds: 15), title: 'SET OVER! REST!\nNew Set will\nstart in');
    if (result ?? false) await _start();
  }

  Future<void> _start() async {
    if (_isRunning) {
      await _handler.start();
    } else if (await CountDown.start(context) ?? false) {
      _isRunning = true;
      await _handler.start();
    }
  }

  @override
  void initState() {
    super.initState();
    _exerciseData = widget.data;
    _targetLoad = _exerciseData.targetLoad;
    _holdTime = _exerciseData.holdTime;
    _restTime = _exerciseData.restTime;
    _handler = DataHandler(targetLoad: _targetLoad);
  }

  @override
  void dispose() {
    _reset();
    _handler.dispose();
    super.dispose();
  }

  String get _lapTime => _isHold ? 'Hold for: ${_holdTime--} s' : 'Rest for: ${_restTime--} s';

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<int>(
            initialData: 0,
            stream: _handler.timeStream,
            builder: (_, AsyncSnapshot<int> snapshot) {
              if (_isRunning) _update();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Text>[
                  Text(
                    '🕒 ${snapshot.data ~/ 60}:${(snapshot.data % 60).toString().padLeft(2, '0')} s',
                    style: const TextStyle(fontSize: 26, color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  Text(_isRunning ? _lapTime : '---', style: const TextStyle(fontSize: 26, color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                ],
              );
            },
          ),
          StreamBuilder<double>(
            initialData: 0,
            stream: _handler.weightStream,
            builder: (_, AsyncSnapshot<double> snapshot) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color.lerp(Colors.yellow[100], Colors.green, snapshot.data / _targetLoad),
                ),
                child: Text(
                  'Set: $_currentSet of ${_exerciseData.sets}   |   Rep: $_currentRep of ${_exerciseData.reps}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              );
            },
          ),
          CustomGraph(series: _handler.getSeries),
          const SizedBox(height: 30),
          GraphControls(start: _start, stop: _handler.stop, reset: _reset),
        ],
      ),
    );
  }
}

class DataHandler {
  DataHandler({this.targetLoad}) {
    Bluetooth.listen(_listener);
  }

  final List<ChartData> dataList = <ChartData>[];

  Timer _timer;
  bool _isRunning = false;
  final double targetLoad;
  ChartSeriesController _graphDataCtrl;
  final Stopwatch _stopwatch = Stopwatch();
  final StreamController<int> _timeCtrl = StreamController<int>();
  final StreamController<double> _weightCtrl = StreamController<double>();
  final List<ChartData> _graphData = <ChartData>[ChartData(load: 0)];

  Stream<int> get timeStream => _timeCtrl.stream;

  Stream<double> get weightStream => _weightCtrl.stream;

  Future<void> start() async {
    if (_timer == null) {
      await Bluetooth.startWeightMeas();
      _isRunning = true;
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _timeCtrl.sink.add(_stopwatch.elapsedMilliseconds ~/ 1000));
    }
  }

  Future<void> stop() async {
    if (_timer != null) {
      _isRunning = false;
      _timer.cancel();
      _timer = null;
    }
  }

  Future<void> reset() async {
    await Bluetooth.stopWeightMeas();
    await stop();
    _stopwatch.stop();
    _stopwatch.reset();
    if (!_timeCtrl.isClosed) _timeCtrl.sink.add(0);
    if (!_weightCtrl.isClosed) _weightCtrl.sink.add(0);
    _graphData.insert(0, ChartData(load: 0));
    _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
  }

  Future<void> dispose() async {
    if (!_timeCtrl.isClosed) await _timeCtrl.close();
    if (!_weightCtrl.isClosed) await _weightCtrl.close();
  }

  void _listener(List<int> _data) {
    if (!_isRunning) return;
    int _counter = 0;
    double _avgTime = 0;
    double _avgWeight = 0;
    double _timeSum = 0;
    double _weightSum = 0;

    if (_data.isNotEmpty && _data[0] == Progressor.RES_WEIGHT_MEAS) {
      for (int x = 2; x < _data.length; x += 8) {
        _weightSum += /*_weight =*/ Uint8List.fromList(_data.getRange(x, x + 4).toList()).buffer.asByteData().getFloat32(0, Endian.little);
        _timeSum += /*_time =*/ Uint8List.fromList(_data.getRange(x + 4, x + 8).toList()).buffer.asByteData().getUint32(0, Endian.little);
        if (_counter++ == 8) {
          _avgWeight = double.parse((_weightSum.abs() / 8.0).toStringAsFixed(2));
          _avgTime = double.parse(((_timeSum / 8.0) / 1000000.0).toStringAsFixed(2));
          dataList.add(ChartData(time: _avgTime, load: _avgWeight));
          _graphData.insert(0, ChartData(load: _avgWeight));
          _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
          if (!_weightCtrl.isClosed) _weightCtrl.sink.add(_avgWeight);
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
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.load,
        dataSource: <ChartData>[ChartData(x: 0, load: targetLoad), ChartData(x: 2, load: targetLoad)],
      ),
    ];
  }
}

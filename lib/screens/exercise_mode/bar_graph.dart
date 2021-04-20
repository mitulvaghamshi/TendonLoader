import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/components/app_frame.dart';
import 'package:tendon_loader/components/countdown.dart';
import 'package:tendon_loader/components/custom_graph.dart';
import 'package:tendon_loader/components/graph_controls.dart';
import 'package:tendon_loader/utils/app/common.dart' show textStyleBold26;
import 'package:tendon_loader/utils/app/constants.dart';
import 'package:tendon_loader/utils/cloud/data_storage.dart';
import 'package:tendon_loader/utils/controller/bluetooth.dart';
import 'package:tendon_loader/utils/controller/create_excel.dart';
import 'package:tendon_loader/utils/modal/chart_data.dart';
import 'package:tendon_loader/utils/modal/prescription.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key, @required this.prescription}) : super(key: key);

  final Prescription prescription;

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
  Prescription _prescription;
  DateTime _dateTime;
  bool _isComplete = false;

  String get _lapTime => _isRunning
      ? _isHold
          ? 'Hold for: ${_holdTime--} s'
          : 'Rest for: ${_restTime--} s'
      : '---';

  String get _progress => 'Set: $_currentSet of ${_prescription.sets}  |  Rep: $_currentRep of ${_prescription.reps}';

  String _fromSecs(int secs) => '🕒 ${secs ~/ 60}:${(secs % 60).toString().padLeft(2, '0')} s';

  Future<void> _start() async {
    if (_isRunning) {
      await _handler.start();
    } else if (await CountDown.start(context) ?? false) {
      _isRunning = true;
      await _handler.start();
      _dateTime = DateTime.now();
    }
  }

  Future<void> _reset() async {
    if (_isRunning) {
      _isHold = true;
      _isRunning = false;
      _currentRep = _currentSet = 1;
      _holdTime = _prescription.holdTime;
      _restTime = _prescription.restTime;
      await _handler.reset();
      await DataStorage.export(_handler.dataList, _dateTime, Keys.KEY_PREFIX_EXERCISE, _isComplete, prescription: _prescription);
    }
  }

  Future<void> _rest() async {
    await _handler.stop();
    final bool result = await CountDown.start(context, duration: const Duration(seconds: 15), title: 'SET OVER!\nREST!');
    if (result ?? false) await _start();
  }

  void _update() {
    if (_holdTime == 0) {
      _isHold = false;
      _holdTime = _prescription.holdTime;
    }
    if (_restTime == 0) {
      _isHold = true;
      _restTime = _prescription.restTime;
      if (_currentRep == _prescription.reps) {
        if (_currentSet == _prescription.sets) {
          _isComplete = true;
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

  @override
  void initState() {
    super.initState();
    _prescription = widget.prescription;
    _targetLoad = _prescription.targetLoad;
    _holdTime = _prescription.holdTime;
    _restTime = _prescription.restTime;
    _handler = DataHandler(targetLoad: _targetLoad);
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
          StreamBuilder<int>(
            initialData: 0,
            stream: _handler.timeStream,
            builder: (_, AsyncSnapshot<int> snapshot) {
              if (_isRunning) _update();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Text>[
                  Text(_fromSecs(snapshot.data), style: textStyleBold26.copyWith(color: Colors.green)),
                  Text(_lapTime, style: textStyleBold26.copyWith(color: Colors.deepOrange)),
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
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: snapshot.data >= _targetLoad ? Colors.green : Colors.yellow[200],
                ),
                child: Text(_progress, style: textStyleBold26.copyWith(color: Colors.black, letterSpacing: -1)),
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

  Timer _timer;
  bool _isRunning = false;
  final double targetLoad;
  ChartSeriesController _graphDataCtrl;
  final Stopwatch _stopwatch = Stopwatch();
  final List<ChartData> dataList = <ChartData>[];
  final List<ChartData> _graphData = <ChartData>[ChartData()];
  final StreamController<int> _timeCtrl = StreamController<int>();
  final StreamController<double> _weightCtrl = StreamController<double>();

  Stream<int> get timeStream => _timeCtrl.stream;

  Stream<double> get weightStream => _weightCtrl.stream;

  Future<void> start() async {
    if (_timer == null) {
      if (!_isRunning) {
        await Bluetooth.startWeightMeas();
        _isRunning = true;
      }
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _timeCtrl.sink.add(_stopwatch.elapsedMilliseconds ~/ 1000));
    }
  }

  Future<void> stop() async {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  Future<void> reset() async {
    await Bluetooth.stopWeightMeas();
    await stop();
    _stopwatch.stop();
    _stopwatch.reset();
    _isRunning = false;
    if (!_timeCtrl.isClosed) _timeCtrl.sink.add(0);
    if (!_weightCtrl.isClosed) _weightCtrl.sink.add(0);
    _graphData.insert(0, ChartData());
    _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
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
        yValueMapper: (ChartData data, _) => data.load,
        xValueMapper: (ChartData data, _) => data.time.toInt(),
        dataSource: <ChartData>[ChartData(load: targetLoad), ChartData(time: 2, load: targetLoad)],
      ),
    ];
  }
}

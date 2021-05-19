import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/app/custom/confirm_dialod.dart';
import 'package:tendon_loader/app/custom/countdown.dart';
import 'package:tendon_loader/app/custom/custom_controls.dart';
import 'package:tendon_loader/app/custom/custom_graph.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/shared/common.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/extensions.dart';
import 'package:tendon_loader/shared/handler/data_handler.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/data_model.dart';
import 'package:tendon_loader/shared/modal/prescription.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key, @required this.prescription}) : super(key: key);

  final Prescription prescription;

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  final StreamController<double> _timeCtrl = StreamController<double>();
  final List<ChartData> _graphData = <ChartData>[];
  final List<ChartData> _dataList = <ChartData>[];
  final DataHandler _handler = DataHandler();

  ChartSeriesController _graphCtrl;
  DateTime _dateTime;

  double _targetLoad = 0;
  int _currentSet = 1;
  int _currentRep = 1;
  int _holdTime = 0;
  int _restTime = 0;

  bool _isComplete = false;
  bool _isRunning = false;
  bool _isSetRest = false;
  bool _hasData = false;
  bool _isHold = true;

  double _minTime = 0;
  int _minSec = 0;

  int _setRestTime;

  String get _lapTime => _isRunning
      ? _isHold
          ? 'Hold for: ${_holdTime--} s'
          : 'Rest for: ${_restTime--} s'
      : '...';

  String get _progress =>
      'Set: $_currentSet of ${widget.prescription.sets} ● Rep: $_currentRep of ${widget.prescription.reps}';

  Future<void> _start() async {
    if (_isSetRest && _isRunning) {
      _isSetRest = false;
    } else if (!_isRunning && _hasData) {
      await _onExit();
    } else if (await CountDown.start(context) ?? false) {
      await Bluetooth.startWeightMeas();
      _dateTime = DateTime.now();
      _isComplete = false;
      _isRunning = true;
      _hasData = true;
      _isSetRest = false;
    }
  }

  Future<void> _reset() async {
    if (_isRunning) {
      _isRunning = false;
      await Bluetooth.stopWeightMeas();
      _handler.clear();
      _timeCtrl.sink.add(0);
      _holdTime = widget.prescription.holdTime;
      _restTime = widget.prescription.restTime;
      _currentRep = _currentSet = 1;
      _isHold = true;
      _minTime = 0;
      _minSec = 0;
    }
  }

  Future<void> _setRest() async {
    final bool result = await CountDown.start(
      context,
      title: 'SET OVER!\nREST!',
      duration: Duration(seconds: _setRestTime),
    );
    if (result ?? false) await _start();
  }

  void stop() => _isSetRest = true;

  void _updateCounters() {
    if (_isHold && _holdTime == 0) {
      _isHold = false;
      _holdTime = widget.prescription.holdTime;
    } else if (!_isHold && _restTime == 0) {
      _isHold = true;
      _restTime = widget.prescription.restTime;
      if (_currentRep == widget.prescription.reps) {
        if (_currentSet == widget.prescription.sets) {
          _isComplete = true;
          _reset();
        } else {
          _setRest();
          _currentSet++;
          _currentRep = 1;
          _isSetRest = true;
        }
      } else {
        _currentRep++;
      }
    }
  }

  Future<bool> _onExit() async {
    if (_isRunning) await _reset();
    if (!_hasData) return true;
    final bool result = await ConfirmDialog.show(
      context,
      model: DataModel(
        dataList: _dataList,
        prescription: widget.prescription,
        sessionInfo: SessionInfo(dateTime: _dateTime, dataStatus: _isComplete, exportType: Keys.KEY_PREFIX_EXERCISE),
      ),
    );
    if (result == null) {
      return false;
    } else {
      _hasData = false;
    }
    return result;
  }

  void _listener(List<int> data) {
    if (_isRunning && data.isNotEmpty && data[0] == Progressor.RES_WEIGHT_MEAS) {
      for (int x = 2; x < data.length; x += 8) {
        final double weight = data.getRange(x, x + 4).toList().toWeight;
        final double time = data.getRange(x + 4, x + 8).toList().toTime;
        if (time > _minTime) {
          _minTime = time;
          final ChartData element = ChartData(load: weight, time: time);
          _dataList.add(element);
          _handler.sink.add(element);
          if (!_isSetRest && time.truncate() > _minSec) {
            _minSec = time.truncate();
            _timeCtrl.sink.add(time);
            _updateCounters();
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Bluetooth.listen(_listener);
    _targetLoad = widget.prescription.targetLoad;
    _holdTime = widget.prescription.holdTime;
    _restTime = widget.prescription.restTime;
    _setRestTime = widget.prescription.setRestTime;
  }

  @override
  void dispose() {
    _reset();
    _handler.dispose();
    _timeCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onExit: _onExit,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<double>(
            initialData: 0,
            stream: _timeCtrl.stream,
            builder: (_, AsyncSnapshot<double> snapshot) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(snapshot.data.toTime, style: tsBold26.copyWith(color: Colors.green)),
                Text(_lapTime, style: tsBold26.copyWith(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          StreamBuilder<ChartData>(
            initialData: ChartData(),
            stream: _handler.stream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              _graphData.insert(0, snapshot.data);
              _graphCtrl?.updateDataSource(updatedDataIndex: 0);
              return Chip(
                padding: const EdgeInsets.all(10),
                label: Text(_progress, style: tsBold26.copyWith(color: Colors.black)),
                backgroundColor: snapshot.data.load > _targetLoad ? Colors.green : Colors.yellow[200],
              );
            },
          ),
          CustomGraph(
            graphData: _graphData,
            graphCtrl: (ChartSeriesController ctrl) => _graphCtrl = ctrl,
            lineData: <ChartData>[ChartData(load: _targetLoad), ChartData(time: 2, load: _targetLoad)],
          ),
          GraphControls(start: _start, stop: stop, reset: _reset),
        ],
      ),
    );
  }
}

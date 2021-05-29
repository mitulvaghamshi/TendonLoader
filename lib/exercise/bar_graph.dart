import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' show ChartSeriesController;
import 'package:tendon_loader/custom/confirm_dialod.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart'
    show exportDataList, deviceName, startWeightMeasuring, stopWeightMeasuring;
import 'package:tendon_loader/handler/clip_player.dart';
import 'package:tendon_loader/handler/data_handler.dart' show graphDataStream;
import 'package:tendon_support_lib/tendon_support_lib.dart' show AppFrame, CountDown, GraphControls, Keys;
import 'package:tendon_support_module/modal/chartdata.dart';
import 'package:tendon_support_module/modal/data_model.dart';
import 'package:tendon_support_module/modal/prescription.dart';
import 'package:tendon_support_module/modal/session_info.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key, required this.prescription}) : super(key: key);

  final Prescription prescription;

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  final List<ChartData> _graphData = <ChartData>[];

  ChartSeriesController? _graphCtrl;
  late DateTime _dateTime;

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

  int _minSec = 0;

  late int _setRestTime;

  String get _lapTime => _isRunning
      ? _isHold
          ? 'Hold for: $_holdTime s'
          : 'Rest for: $_restTime s'
      : '•••';

  String get _progress =>
      'Set: $_currentSet/${widget.prescription.sets} • Rep: $_currentRep/${widget.prescription.reps}';

  Future<void> _start() async {
    if (_isSetRest && _isRunning) {
      _isSetRest = false;
    } else if (!_isRunning && _hasData) {
      await _onExit();
    } else if (await CountDown.start(context) ?? false) {
      await startWeightMeasuring();
      exportDataList.clear();
      play(Clip.start);
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
      play(Clip.stop);
      await stopWeightMeasuring();
      _holdTime = widget.prescription.holdTime!;
      _restTime = widget.prescription.restTime!;
      _currentRep = _currentSet = 1;
      _isHold = true;
      _minSec = 0;
      if (_isComplete) await _congrats();
    }
  }

  Future<void> _setRest() async {
    final bool? result = await CountDown.start(
      context,
      title: 'Set Over, Rest!!!',
      duration: Duration(seconds: _setRestTime),
    );
    if (result ?? false) await _start();
    // Future<void>.delayed(const Duration(milliseconds: 5), () async {
    //   final bool? result = await CountDown.start(
    //     context,
    //     title: 'Set Over, Rest!!!',
    //     duration: Duration(seconds: _setRestTime),
    //   );
    //   if (result ?? false) await _start();
    // });
  }

  void stop() => _isSetRest = true;

  void _updateCounters() {
    if (_isHold && _holdTime == 0) {
      _isHold = false;
      _holdTime = widget.prescription.holdTime!;
    } else if (!_isHold && _restTime == 0) {
      _isHold = true;
      _restTime = widget.prescription.restTime!;
      if (_currentRep == widget.prescription.reps!) {
        if (_currentSet == widget.prescription.sets!) {
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
    if (!_hasData) return true;
    final bool? result = await ConfirmDialog.show(
      context,
      model: DataModel(
        dataList: exportDataList,
        prescription: widget.prescription,
        sessionInfo: SessionInfo(
          dateTime: _dateTime,
          dataStatus: _isComplete,
          progressorId: deviceName,
          exportType: Keys.keyPrefixExcercise,
        ),
      ),
    );
    if (result == null) {
      return false;
    } else {
      _hasData = false;
    }
    return result;
  }

  Future<void> _congrats() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const <Widget>[
              Icon(Icons.emoji_events_rounded, size: 50, color: Colors.green),
              Text('Congratulations!!!', textAlign: TextAlign.center, style: TextStyle(fontSize: 26)),
            ]),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: const Text(
            'Exercise session completed!\nGreat work!',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton.icon(
              label: const Text('Next'),
              icon: const Icon(Icons.arrow_forward),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        );
      },
    );
    await _onExit();
  }

  @override
  void initState() {
    super.initState();
    _targetLoad = widget.prescription.targetLoad!;
    _holdTime = widget.prescription.holdTime!;
    _restTime = widget.prescription.restTime!;
    _setRestTime = widget.prescription.setRestTime!;
  }

  @override
  void dispose() {
    _reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onExit: _onExit,
      child: Column(
        children: <Widget>[
          StreamBuilder<ChartData>(
            stream: graphDataStream,
            initialData: const ChartData(),
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              _graphData.insert(0, snapshot.data!);
              _graphCtrl?.updateDataSource(updatedDataIndex: 0);
              if (!_isSetRest && snapshot.data!.time!.truncate() > _minSec) {
                _minSec = snapshot.data!.time!.truncate();
                _isHold ? _holdTime-- : _restTime--;
                _updateCounters();
              }
              return FittedBox(
                fit: BoxFit.fitWidth,
                child: Column(
                  children: <Widget>[
                    Text(
                      _lapTime,
                      style: const TextStyle(fontSize: 40, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Chip(
                      padding: const EdgeInsets.all(16),
                      label: Text(_progress, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                      backgroundColor: snapshot.data!.load! > _targetLoad ? Colors.green : Colors.yellow[200],
                    ),
                  ],
                ),
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

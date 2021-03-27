import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/components/countdown.dart';
import 'package:tendon_loader/utils/create_xlsx.dart';
import 'package:tendon_loader/utils/data_handler.dart';
import 'package:tendon_loader/utils/exercise_data.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key/*?*/ key, /*required*/ @required this.exerciseData}) : super(key: key);

  final ExerciseData/*?*/ exerciseData;

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> with CreateXLSX {
  int/*?*/ _holdTime = 0;
  int/*?*/ _restTime = 0;
  int _currentSet = 1;
  int _currentRep = 1;
  double/*?*/ _targetLoad = 0;
  bool _isHold = true;
  bool _isRunning = false;
  DataHandler _handler;
  ExerciseData/*?*//*!*/ _exerciseData;

  void _update() {
    if (_holdTime == 0) {
      _isHold = false;
      _holdTime = _exerciseData/*!*/.holdTime;
    }
    if (_restTime == 0) {
      _isHold = true;
      _restTime = _exerciseData/*!*/.restTime;
      if (_currentRep == _exerciseData/*!*/.reps) {
        if (_currentSet == _exerciseData/*!*/.sets) {
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
    _isRunning = false;
    _holdTime = _restTime = 0;
    _currentRep = _currentSet = 1;
    await _handler.reset();
  }

  Future<void> _rest() async {
    await _handler.stop();
    final bool/*?*/ result = await CountDown.start(context, duration: const Duration(seconds: 15), title: 'SET OVER! REST!\nNew Set will\nstart in');
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
    _exerciseData = widget.exerciseData;
    _targetLoad = _exerciseData/*!*/.targetLoad;
    _holdTime = _exerciseData/*!*/.holdTime;
    _restTime = _exerciseData/*!*/.restTime;
    _handler = DataHandler(targetLoad: _targetLoad);
  }

  @override
  void dispose() {
    _handler.dispose();
    super.dispose();
  }

  String get _lapTime => _isHold ? 'Hold for: ${_holdTime--} s' : 'Rest for: ${_restTime--} s';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
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
                      '🕒 ${snapshot.data/*!*/ ~/ 60}:${(snapshot.data/*!*/ % 60).toString().padLeft(2, '0')} s',
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
                    color: Color.lerp(Colors.yellow[100], Colors.green, snapshot.data/*!*/ / _targetLoad/*!*/),
                  ),
                  child: Text(
                    'Set: $_currentSet of ${_exerciseData/*!*/.sets}   |   Rep: $_currentRep of ${_exerciseData/*!*/.reps}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                );
              },
            ),
            Expanded(
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                series: _handler.getSeries(),
                primaryXAxis: NumericAxis(minimum: 0, isVisible: false),
                primaryYAxis: NumericAxis(
                  maximum: 30,
                  labelFormat: '{value} kg',
                  axisLine: AxisLine(width: 0),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <FloatingActionButton>[
                FloatingActionButton(
                  onPressed: _start,
                  heroTag: 'start-btn',
                  child: const Icon(Icons.play_arrow_rounded),
                ),
                FloatingActionButton(
                  onPressed: _handler.stop,
                  heroTag: 'stop-btn',
                  child: const Icon(Icons.stop_rounded),
                ),
                FloatingActionButton(
                  onPressed: _reset,
                  heroTag: 'reset-btn',
                  child: const Icon(Icons.replay_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

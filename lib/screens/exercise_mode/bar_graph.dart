import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/components/countdown.dart';
import 'package:tendon_loader/utils/chart_data.dart';
import 'package:tendon_loader/utils/data_handler.dart';
import 'package:tendon_loader/utils/exercise_data.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key, @required this.exerciseData})
      : assert(exerciseData != null, 'Exercise data required'),
        super(key: key);

  final ExerciseData exerciseData;

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  int _holdTime = 0;
  int _currentSet = 1;
  int _currentRep = 1;
  bool _isHold = false;
  bool _isRunning = false;
  double _targetLoad;
  DataHandler _handler;
  ExerciseData _exerciseData;

  @override
  void initState() {
    super.initState();
    _exerciseData = widget.exerciseData;
    _targetLoad = _exerciseData.targetLoad;
    _holdTime = _exerciseData.holdTime;
    _handler = DataHandler(lineData: [ChartData(x: 0, weight: _targetLoad), ChartData(x: 2, weight: _targetLoad)]);
  }

  @override
  void dispose() {
    _handler.dispose();
    super.dispose();
  }

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
          children: [
            StreamBuilder<int>(
              initialData: 0,
              stream: _handler.timeStream,
              builder: (_, snapshot) {
                if (_isRunning) {
                  if (_currentRep == _exerciseData.reps) {
                    if (_currentSet == _exerciseData.sets) {
                      _isRunning = false;
                      _stop();
                    } else {
                      _currentRep = 1;
                      _currentSet++;
                    }
                  } else {
                    if (_isHold && _holdTime == 0) {
                      _isHold = false;
                      _holdTime = _exerciseData.holdTime;
                    } else {
                      _startRep();
                    }
                  }
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '🕒 ${(snapshot.data ~/ 60)}:${(snapshot.data % 60).toString().padLeft(2, '0')} s',
                      style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Hold for: ${_isHold ? _holdTime-- : 0} s',
                      style: const TextStyle(fontSize: 20, color: Colors.deepOrange, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            StreamBuilder<double>(
              initialData: 0,
              stream: _handler.weightStream,
              builder: (_, snapshot) {
                if (snapshot.data >= _targetLoad && _isRunning) _isHold = true;
                return Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: snapshot.data >= _targetLoad ? Colors.green[400] : Colors.yellow[300],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Set: $_currentSet of ${_exerciseData.sets}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rep: $_currentRep of ${_exerciseData.reps}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                series: _handler.getSeries(),
                plotAreaBorderWidth: 0,
                primaryXAxis: NumericAxis(minimum: 0, isVisible: false),
                primaryYAxis: NumericAxis(
                  maximum: 30,
                  labelFormat: '{value} kg',
                  axisLine: AxisLine(width: 0),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: _start,
                  heroTag: 'exercise-mode-start-btn',
                  child: const Icon(Icons.play_arrow_rounded),
                ),
                FloatingActionButton(
                  onPressed: _stop,
                  heroTag: 'exercise-mode-stop-btn',
                  child: const Icon(Icons.stop_rounded),
                ),
                FloatingActionButton(
                  onPressed: _reset,
                  heroTag: 'exercise-mode-reset-btn',
                  child: const Icon(Icons.replay_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _reset() async {
    await _handler.reset();
    _isRunning = false;
    _currentRep = 1;
    _currentSet = 1;
  }

  void _stop() {
    _handler.stop();
  }

  Future _startRep() async {
    _stop();
    await CountDown.start(
      context,
      duration: Duration(seconds: _exerciseData.restTime),
      title: 'Rep# $_currentRep\nstart in',
    ).then((value) async {
      if (value ?? false) await _start();
    });
  }

  Future _start() async {
    if (_isRunning) {
      await _handler.start();
    } else {
      await CountDown.start(context).then((value) async {
        if (value ?? false) {
          _isRunning = true;
          await _handler.init();
          await _handler.start();
        }
      });
    }
  }
}

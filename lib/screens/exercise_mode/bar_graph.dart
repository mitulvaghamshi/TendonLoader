import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/components/countdown.dart';
import 'package:tendon_loader/utils/bluetooth.dart';
import 'package:tendon_loader/utils/chart_data.dart';
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
  Timer _timer;
  int _currentSet = 1;
  int _currentRep = 1;
  double _targetLoad;
  ExerciseData _exerciseData;
  List<ChartData> _targetLine;
  Bluetooth _bt = Bluetooth();
  Stopwatch _stopwatch = Stopwatch();
  ChartSeriesController _lineDataCtrl;
  ChartSeriesController _graphDataCtrl;
  StreamController<int> _timeCtrl = StreamController<int>()..add(0);
  StreamController<int> _repTimeCtrl = StreamController<int>()..add(0);
  List<ChartData> _measurement = [ChartData(weight: 0)];
  StreamController<double> _weightCtrl = StreamController<double>()..add(0);

  @override
  void initState() {
    super.initState();
    _exerciseData = widget.exerciseData;
    _targetLoad = _exerciseData.targetLoad;
    _targetLine = [ChartData(x: 0, weight: _targetLoad), ChartData(x: 2, weight: _targetLoad)];
    _bt.startNotify();
    _bt.listen(_getData);
  }

  @override
  void dispose() {
    if (_timer?.isActive ?? false) _timer.cancel();
    if (!_repTimeCtrl.isClosed) _repTimeCtrl.close();
    if (!_weightCtrl.isClosed) _weightCtrl.close();
    _bt.stopNotify();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StreamBuilder<int>(
                  stream: _timeCtrl.stream,
                  builder: (_, snapshot) => Text(
                    '🕒 ${snapshot.hasData ? '${(snapshot.data ~/ 60)}:${(snapshot.data % 60).toString().padLeft(2, '0')}' : '0:00'} s',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StreamBuilder<int>(
                  stream: _repTimeCtrl.stream,
                  builder: (_, snapshot) => Text(
                    'Hold for: ${snapshot.data} s',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            StreamBuilder<double>(
              initialData: 0,
              stream: _weightCtrl.stream,
              builder: (_, snapshot) {
                if(snapshot.data >= _targetLoad) {

                }
                return Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: snapshot.data >= _targetLoad ? Colors.green[400] : Colors.yellow[400],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // TODO: make dynamic sets and reps value
                      Text(
                        'Set: $_currentSet of ${widget.exerciseData.sets}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rep: $_currentRep of ${widget.exerciseData.reps}',
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
                series: _getSeries(),
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
                  heroTag: 'exercise-mode-start-btn',
                  child: const Icon(Icons.play_arrow_rounded),
                  onPressed: () async {
                    await CountDown.start(context).then((value) async {
                      if (value) {
                        await _bt.startWeightMeas();
                        _stopwatch.start();
                        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
                          _timeCtrl.add(_stopwatch.elapsedMilliseconds ~/ 1000);
                        });
                      }
                    });
                  },
                ),
                FloatingActionButton(
                  heroTag: 'exercise-mode-stop-btn',
                  child: const Icon(Icons.stop_rounded),
                  onPressed: () async {
                    _timer.cancel();
                    _stopwatch.stop();
                    await _bt.stopWeightMeas();
                  },
                ),
                FloatingActionButton(
                  heroTag: 'exercise-mode-reset-btn',
                  child: const Icon(Icons.replay_rounded),
                  onPressed: () async {
                    await _bt.stopWeightMeas();
                    _timer.cancel();
                    _stopwatch.reset();
                    _timeCtrl.add(0);
                    _weightCtrl.add(0);
                    _measurement.insert(0, const ChartData(weight: 0));
                    _lineDataCtrl.updateDataSource(updatedDataIndexes: [0, 1]);
                    _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<ChartSeries<ChartData, int>> _getSeries() {
    return <ChartSeries<ChartData, int>>[
      ColumnSeries<ChartData, int>(
        width: 0.9,
        color: Colors.blue,
        animationDuration: 0,
        dataSource: _measurement,
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
      LineSeries<ChartData, int>(
        width: 5,
        color: Colors.red,
        animationDuration: 0,
        dataSource: _targetLine,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.weight,
        onRendererCreated: (controller) => _lineDataCtrl = controller,
      ),
    ];
  }

  void _getData(List<int> dataList) {
    int _counter = 0;
    // int _averageTime = 0;
    double _averageWeight = 0;
    if (dataList.isNotEmpty && dataList[0] == Bluetooth.RES_WEIGHT_MEAS) {
      for (int x = 2; x < dataList.length; x += 8) {
        _averageWeight +=
            Uint8List.fromList(dataList.getRange(x, x + 4).toList()).buffer.asByteData().getFloat32(0, Endian.little);
        // _averageTime += Uint8List.fromList(dataList.getRange(x + 4, x + 8).toList()).buffer.asByteData().getUint32(0, Endian.little);
        if (_counter++ == 8) {
          double _weight = double.parse((_averageWeight.abs() / 8.0).toStringAsFixed(2));
          // double _time = double.parse(((_averageTime / 8) / 1000000.0).toStringAsFixed(2));
          if (!_weightCtrl.isClosed) _weightCtrl.add(_weight);
          _measurement.insert(0, ChartData(weight: _weight));
          _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
          _counter = 0;
          // _averageTime = 0;
          _averageWeight = 0;
        }
      }
    }
  }
}

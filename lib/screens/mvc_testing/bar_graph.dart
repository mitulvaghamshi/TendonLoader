import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/components/countdown.dart';
import 'package:tendon_loader/utils/bluetooth.dart';
import 'package:tendon_loader/utils/chart_data.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  Timer _timer;
  double targetLoad = 0;
  Bluetooth _bt = Bluetooth();
  ChartSeriesController _lineDataCtrl;
  ChartSeriesController _graphDataCtrl;
  List<ChartData> _measurement = [const ChartData(weight: 0)];
  StreamController<int> _timeCtrl = StreamController<int>()..add(5);
  StreamController<double> _weightCtrl = StreamController<double>()..add(0);
  List<ChartData> _targetLine = [const ChartData(x: 0, weight: 0), const ChartData(x: 2, weight: 0)];

  @override
  void initState() {
    super.initState();
    _bt.startNotify();
    _bt.listen(_getData);
  }

  @override
  void dispose() {
    if (!_timeCtrl.isClosed) _timeCtrl.close();
    if (!_weightCtrl.isClosed) _weightCtrl.close();
    if (_timer?.isActive ?? false) _timer.cancel();
    _bt.stopNotify();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            StreamBuilder<double>(
              initialData: 0,
              stream: _weightCtrl.stream,
              builder: (_, snapshot) {
                return Text(
                  'MVC: ${snapshot.data.toStringAsFixed(2).padLeft(2, '0')} Kg',
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.green,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<int>(
              stream: _timeCtrl.stream,
              builder: (_, snapshot) => Text(
                'Remaining time: ${snapshot.hasData ? snapshot.data : 5} s',
                style: const TextStyle(
                  fontSize: 26,
                  fontFamily: 'Serif',
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  heroTag: 'mvc-testing-start-btn',
                  child: Icon(Icons.play_arrow_rounded),
                  onPressed: () async {
                    await CountDown.start(context, duration: Duration(seconds: 1)).then((_) async {
                      await _bt.startWeightMeas();
                      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
                        if (timer.tick == 5) {
                          timer.cancel();
                          await _bt.stopWeightMeas();
                        }
                        _timeCtrl.add(5 - timer.tick);
                      });
                    });
                  },
                ),
                FloatingActionButton(
                  heroTag: 'mvc-testing-reset-btn',
                  child: Icon(Icons.replay_rounded),
                  onPressed: () async {
                    await _bt.stopWeightMeas();
                    _timer.cancel();
                    _timeCtrl.add(5);
                    _weightCtrl.add(0);
                    _targetLine.insertAll(0, [const ChartData(x: 0, weight: 0), const ChartData(x: 2, weight: 0)]);
                    _measurement.insert(0, const ChartData(weight: 0));
                    _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
                    _lineDataCtrl.updateDataSource(updatedDataIndexes: [0, 1]);
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
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.lightGreenAccent],
          stops: [0.4, 1],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
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
          _measurement.insert(0, ChartData(weight: _weight));
          _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
          if (!_weightCtrl.isClosed && _weight > targetLoad) {
            _weightCtrl.add(targetLoad = _weight);
            _targetLine.insertAll(0, [ChartData(x: 0, weight: targetLoad), ChartData(x: 2, weight: targetLoad)]);
            _lineDataCtrl.updateDataSource(updatedDataIndexes: [0, 1]);
          }
          _counter = 0;
          // _averageTime = 0;
          _averageWeight = 0;
        }
      }
    }
  }
}

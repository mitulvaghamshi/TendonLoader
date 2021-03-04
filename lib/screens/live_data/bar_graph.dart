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
  Bluetooth _bt = Bluetooth();
  Stopwatch _stopwatch = Stopwatch();
  ChartSeriesController _graphDataCtrl;
  StreamController<int> _timeCtrl = StreamController<int>()..add(0);
  List<ChartData> _measurement = [const ChartData(weight: 0)];

  @override
  void initState() {
    super.initState();
    _bt.startNotify();
    _bt.listen(_getData);
  }

  @override
  void dispose() {
    if (_timer?.isActive ?? false) _timer.cancel();
    if (!_timeCtrl.isClosed) _timeCtrl.close();
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
            StreamBuilder<int>(
              stream: _timeCtrl.stream,
              builder: (_, snapshot) => Text(
                'Time elapsed: ${snapshot.hasData ? '${(snapshot.data ~/ 60)}:${(snapshot.data % 60).toString().padLeft(2, '0')}' : '0:00'} s',
                style: const TextStyle(
                  fontSize: 26,
                  fontFamily: 'Serif',
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                series: _getSeries(),
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(minimum: 0, isVisible: false),
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
                  heroTag: 'live-data-start-btn',
                  child: const Icon(Icons.play_arrow_rounded),
                  onPressed: () async {
                    await CountDown.start(context).then((value) async {
                      if (value != null && value) {
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
                  heroTag: 'live-data-reset-btn',
                  child: const Icon(Icons.replay_rounded),
                  onPressed: () async {
                    await _bt.stopWeightMeas();
                    _timer.cancel();
                    _stopwatch.stop();
                    _stopwatch.reset();
                    _timeCtrl.add(0);
                    _measurement.insert(0, const ChartData(weight: 0));
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
          textStyle: TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
        ),
        onRendererCreated: (controller) => _graphDataCtrl = controller,
        borderRadius: const BorderRadius.only(topLeft: const Radius.circular(20), topRight: const Radius.circular(20)),
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

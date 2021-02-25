import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/components/bluetooth.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/utils/chart_data.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({
    Key key,
    this.isLiveData = false,
    this.isExerciseMode = false,
    this.isMVICTesting = false,
  }) : super(key: key);

  final bool isLiveData;
  final bool isExerciseMode;
  final bool isMVICTesting;

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  Stopwatch _stopwatch;
  double _targetWeight;
  List<ChartData> _measurement;
  ChartSeriesController _graphDataController;
  StreamController<double> _weightController;

  @override
  void initState() {
    super.initState();
    if (!widget.isMVICTesting) {
      _stopwatch = Stopwatch();
    }
    if (!widget.isLiveData) {
      _targetWeight = widget.isExerciseMode ? 5.5 : 0;
      _weightController = StreamController<double>()..add(0);
    }
    _measurement = [ChartData(weight: 0)];
    Bluetooth.instance.startNotify;
    Bluetooth.instance.listen(_getData);
  }

  @override
  void dispose() {
    if (!widget.isLiveData && !_weightController.isClosed) _weightController.close();
    Bluetooth.instance.stopNotify;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                widget.isMVICTesting
                    ? StreamBuilder<double>(
                        initialData: 0,
                        stream: _weightController.stream,
                        builder: (_, snapshot) {
                          return Text(
                            'MVIC: ${snapshot.data.toStringAsPrecision(2).padLeft(2, '0')} Kg',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
                          );
                        },
                      )
                    : StreamBuilder<int>(
                        stream:
                            Stream.periodic(Duration(seconds: 1), (value) => (_stopwatch.elapsedMilliseconds ~/ 1000)),
                        builder: (_, snapshot) {
                          String _elapsedTime = '--:--';
                          if (snapshot.hasData && snapshot.data > 0) {
                            _elapsedTime =
                                '${(snapshot.data ~/ 60).toString().padLeft(2, '0')}:${(snapshot.data % 60).toString().padLeft(2, '0')}';
                          }
                          return Text(
                            'Time elapsed: $_elapsedTime',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
                          );
                        },
                      ),
              ],
            ),
            SizedBox(height: widget.isLiveData ? 0 : 20),
            widget.isExerciseMode
                ? StreamBuilder<double>(
                    initialData: 0,
                    stream: _weightController.stream,
                    builder: (_, snapshot) => Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: snapshot.data >= _targetWeight ? Colors.green : Colors.yellow,
                      ),
                    ),
                  )
                : const SizedBox(),
            SizedBox(height: widget.isMVICTesting ? 0 : 20),
            Expanded(
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryYAxis: NumericAxis(
                  interval: 1,
                  maximum: 15,
                  labelFormat: '{value} kg',
                  axisLine: AxisLine(width: 0),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                series: _getSeries(),
                primaryXAxis: widget.isExerciseMode
                    ? NumericAxis(minimum: 0, isVisible: false)
                    : CategoryAxis(minimum: 0, isVisible: false),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  isFab: true,
                  icon: Icons.play_arrow_rounded,
                  onPressed: () async {
                    await Bluetooth.instance.startWeightMeasurement;
                    if (!widget.isMVICTesting) _stopwatch.start();
                  },
                ),
                widget.isMVICTesting
                    ? const SizedBox()
                    : CustomButton(
                        isFab: true,
                        icon: Icons.stop_rounded,
                        onPressed: () async {
                          await Bluetooth.instance.stopWeightMeasurement;
                          _stopwatch.stop();
                        },
                      ),
                CustomButton(
                  isFab: true,
                  icon: Icons.replay_rounded,
                  onPressed: () async {
                    await Bluetooth.instance.stopWeightMeasurement;
                    _measurement.insert(0, ChartData(weight: 0));
                    _graphDataController.updateDataSource(updatedDataIndex: 0);
                    if (!widget.isMVICTesting)
                      _stopwatch.reset();
                    else
                      _weightController.add(0);
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
    List<ChartSeries<ChartData, int>> components = [];
    components.add(ColumnSeries<ChartData, int>(
      width: 0.9,
      color: Colors.blue,
      animationDuration: 0,
      dataSource: _measurement,
      xValueMapper: (data, _) => 1,
      yValueMapper: (data, _) => data.weight,
      dataLabelSettings: DataLabelSettings(
        isVisible: true,
        labelAlignment: ChartDataLabelAlignment.bottom,
        textStyle: TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
      ),
      onRendererCreated: (controller) => _graphDataController = controller,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ));
    if (widget.isExerciseMode) {
      components.add(LineSeries<ChartData, int>(
        width: 5,
        color: Colors.red,
        animationDuration: 0,
        dataSource: [ChartData(x: 0, weight: _targetWeight), ChartData(x: 2, weight: _targetWeight)],
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.weight,
      ));
    }
    return components;
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
          if (!_weightController.isClosed) {
            if (widget.isMVICTesting && _weight > _targetWeight)
              _weightController.add(_targetWeight = _weight);
            else if (widget.isExerciseMode) _weightController.add(_weight);
          }
          _graphDataController.updateDataSource(updatedDataIndex: 0);
          _counter = 0;
          _averageTime = 0;
          _averageWeight = 0;
        }
      }
    }
  }
}

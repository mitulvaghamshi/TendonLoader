import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/components/bluetooth.dart';
import 'package:tendon_loader/components/custom_button.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  Timer _timer;
  double _targetWeight = 4;
  List<ChartData> _threshold;
  List<ChartData> _measurement;
  ChartSeriesController _graphDataController;
  StreamController<int> _timeController = StreamController<int>();
  StreamController<bool> _colorController = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    _measurement = [ChartData(weight: 0)];
    _colorController.add(false);
    _threshold = [ChartData(x: 0, weight: _targetWeight), ChartData(x: 2, weight: _targetWeight)];
    Bluetooth.instance.startNotify;
    Bluetooth.instance.listen(_getData);
  }

  @override
  void dispose() {
    if (_timeController.isClosed) _timeController.close();
    if (_colorController.isClosed) _colorController.close();
    Bluetooth.instance.stopNotify;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(const Radius.circular(16))),
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StreamBuilder<int>(
                  stream: _timeController.stream,
                  builder: (_, snapshot) {
                    String _elapsedTime = '--:--';
                    if (snapshot.hasData && snapshot.data > 0) {
                      _elapsedTime = '${(snapshot.data ~/ 60)} min: ${snapshot.data % 60} sec';
                    }
                    return Text(
                      'Time elapsed: $_elapsedTime',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            StreamBuilder<bool>(
              stream: _colorController.stream,
              initialData: false,
              builder: (_, snapshot) => Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(const Radius.circular(20)),
                  color: snapshot.data ? Colors.green : Colors.yellow,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryYAxis: NumericAxis(
                  interval: 1,
                  maximum: 15,
                  labelFormat: '{value} kg',
                  axisLine: AxisLine(width: 0),
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                series: _getSeries(),
                enableSideBySideSeriesPlacement: false,
                primaryXAxis: NumericAxis(minimum: 0, isVisible: false),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  isFab: true,
                  color: Colors.green,
                  icon: Icons.play_arrow_rounded,
                  onPressed: () async {
                    if (_timer == null || !_timer.isActive) {
                      _timer = Timer.periodic(Duration(seconds: 1), (timer) => _timeController.add(timer.tick));
                    }
                    await Bluetooth.instance.startWeightMeasurement;
                  },
                ),
                CustomButton(
                  isFab: true,
                  color: Colors.red,
                  icon: Icons.stop_rounded,
                  onPressed: _resetTask,
                ),
                CustomButton(
                  isFab: true,
                  color: Colors.yellow,
                  icon: Icons.refresh_rounded,
                  onPressed: () async {
                    await _resetTask();
                    _timeController.add(0);
                    _measurement.insert(0, ChartData(weight: 0));
                    _graphDataController.updateDataSource(updatedDataIndex: 0);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetTask() async {
    if (_timer != null && _timer.isActive) _timer.cancel();
    await Bluetooth.instance.stopWeightMeasurement;
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
          labelAlignment: ChartDataLabelAlignment.bottom,
          textStyle: TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
        ),
        onRendererCreated: (controller) => _graphDataController = controller,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      LineSeries<ChartData, int>(
        width: 5,
        color: Colors.red,
        dataSource: _threshold,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.weight,
      ),
    ];
  }

  void _getData(List<int> dataList) {
    double _avgWeightOf8Rec = 0;
    int _avgTimeof8Rec = 0;
    int _countOf8Rec = 0;
    if (dataList.isNotEmpty && dataList[0] == Bluetooth.RES_WEIGHT_MEAS) {
      for (int x = 2; x < dataList.length; x += 8) {
        _countOf8Rec++;
        _avgWeightOf8Rec +=
            Uint8List.fromList(dataList.getRange(x, x + 4).toList()).buffer.asByteData().getFloat32(0, Endian.little);
        _avgTimeof8Rec += Uint8List.fromList(dataList.getRange(x + 4, x + 4 + 4).toList())
            .buffer
            .asByteData()
            .getUint32(0, Endian.little);
        if (_countOf8Rec == 8) {
          double _time = double.parse(((_avgTimeof8Rec / 8) / 1000000.0).toStringAsFixed(2));
          double _weight = double.parse((_avgWeightOf8Rec.abs() / 8.0).toStringAsFixed(2));
          _measurement.insert(0, ChartData(weight: _weight));
          _graphDataController.updateDataSource(updatedDataIndex: 0);
          _colorController.add(_weight >= _targetWeight);
          _countOf8Rec = 0;
          _avgWeightOf8Rec = 0;
          _avgTimeof8Rec = 0;
        }
      }
    }
  }
}

class ChartData {
  ChartData({this.x, this.time, this.weight});

  final int x;
  final double time;
  final double weight;
}

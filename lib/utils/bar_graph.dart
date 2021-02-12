import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/components/bluetooth.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  List<ChartData> _measurement;
  List<ChartData> _threshold;
  ChartSeriesController _graphDataController;

  @override
  void initState() {
    super.initState();
    _measurement = [ChartData(y: 3)];
    _threshold = [ChartData(x: 0, y: 3), ChartData(x: 2, y: 3)];
    Bluetooth.instance.startNotify;
  }

  @override
  void dispose() {
    Bluetooth.instance.stopNotify;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        SizedBox(
          height: 500,
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
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              onPressed: () async => await Bluetooth.instance.stopWeightMeasurement,
              heroTag: 'tag-stop-btn',
              child: Icon(Icons.stop_rounded),
            ),
            FloatingActionButton(
              onPressed: () async {
                await Bluetooth.instance.startWeightMeasurement;
                Bluetooth.instance.listen(_getData);
              },
              heroTag: 'tag-play-btn',
              child: Icon(Icons.play_arrow_rounded),
            ),
            FloatingActionButton(
              onPressed: () async {
                await Bluetooth.instance.stopWeightMeasurement;
                _measurement = [ChartData(y: 0)];
                _graphDataController.updateDataSource(updatedDataIndex: 0);
              },
              heroTag: 'tag-reset-btn',
              child: Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
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
        yValueMapper: (data, _) => data.y,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.bottom,
          textStyle: TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
        ),
        onRendererCreated: (ChartSeriesController controller) => _graphDataController = controller,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      LineSeries<ChartData, int>(
        width: 5,
        color: Colors.red,
        dataSource: _threshold,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.y,
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
          _measurement.insert(
            0,
            ChartData(
              y: double.parse((_avgWeightOf8Rec.abs() / 8.0).toStringAsFixed(2)),
              time: double.parse(((_avgTimeof8Rec / 8) / 1000000.0).toStringAsFixed(2)),
            ),
          );
          _graphDataController.updateDataSource(updatedDataIndex: 0);
          _countOf8Rec = 0;
          _avgWeightOf8Rec = 0;
          _avgTimeof8Rec = 0;
        }
      }
    }
  }
}

class ChartData {
  ChartData({this.x, this.y, this.time});

  final int x;
  final double y;
  final double time;
}

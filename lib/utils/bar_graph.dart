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
  Color _color = Colors.blue;
  List<ChartData> _chartData;
  ChartSeriesController _graphDataController;

  @override
  void initState() {
    super.initState();
    _chartData = [ChartData(y1: 0)];
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
            primaryXAxis: CategoryAxis(isVisible: false),
            primaryYAxis: NumericAxis(
              interval: 1,
              labelFormat: '{value} kg',
              axisLine: AxisLine(width: 0),
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            series: _getStackedColumnSeries(),
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
                _chartData = [ChartData(y1: 0)];
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

  List<StackedColumnSeries<ChartData, int>> _getStackedColumnSeries() {
    return <StackedColumnSeries<ChartData, int>>[
      StackedColumnSeries<ChartData, int>(
        width: 0.9,
        color: _color,
        dataSource: _chartData,
        animationDuration: 0,
        xValueMapper: (data, _) => 0,
        yValueMapper: (data, _) => data.y1,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.bottom,
          textStyle: TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
        ),
        onRendererCreated: (ChartSeriesController controller) => _graphDataController = controller,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
          _chartData.insert(
            0,
            ChartData(
              y1: double.parse((_avgWeightOf8Rec.abs() / 8.0).toStringAsFixed(2)),
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
  ChartData({this.y1, this.y2, this.time});

  final double y1;
  final double y2;
  final double time;
}

/*
class ChartData {
  ChartData({this.x, this.y});

  final String x;
  final double y;
}

 List<ColumnSeries<ChartData, String>> _getSeries() {
    return <ColumnSeries<ChartData, String>>[
      _columnSeries(ChartData(x: '', y: 7.5), Colors.green[600]),
    ];
  }

  ColumnSeries<ChartData, String> _columnSeries(ChartData data, Color color) {
    return ColumnSeries<ChartData, String>(
      width: 0.9,
      color: color,
      dataSource: [data],
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      xValueMapper: (ChartData value, _) => value.x,
      yValueMapper: (ChartData value, _) => value.y,
      dataLabelSettings: DataLabelSettings(
        isVisible: true,
        labelAlignment: ChartDataLabelAlignment.top,
        textStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
    );
  }

    List<StackedColumnSeries<ChartData, String>> _getStackedColumnSeriesTemp() {
    return <StackedColumnSeries<ChartData, String>>[
      StackedColumnSeries<ChartData, String>(
        width: 0.9,
        color: Colors.blue,
        dataSource: [chartData],
        xValueMapper: (data, _) => '',
        yValueMapper: (data, _) => data.y1,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
          textStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
      StackedColumnSeries<ChartData, String>(
        width: 0.9,
        color: Colors.green,
        dataSource: [chartData],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        xValueMapper: (data, _) => '',
        yValueMapper: (data, _) => data.y2,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
          textStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
    ];
  }
 */

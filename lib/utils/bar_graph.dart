import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/utils/bluetooth_args.dart';

class BarGraph extends StatefulWidget {
  final BluetoothArgs args;

  const BarGraph({Key key, this.args}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  List<ChartData> chartData;
  ChartSeriesController _graphDataController;

  @override
  void initState() {
    super.initState();
    chartData = [ChartData(y1: 0, y2: 0, time: 0)];
    widget.args.mDataCharacteristic.setNotifyValue(true);
  }

  @override
  void dispose() {
    widget.args.mDataCharacteristic.setNotifyValue(false);
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
              maximum: 10,
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
              onPressed: () async {
                await widget.args.mControlCharacteristic.write([102]);
              },
              heroTag: 'tag-stop-btn',
              child: Icon(Icons.stop_rounded),
            ),
            FloatingActionButton(
              onPressed: () async {
                await widget.args.mControlCharacteristic.write([101]);
                widget.args.mDataCharacteristic.value.listen(_getData);
              },
              heroTag: 'tag-play-btn',
              child: Icon(Icons.play_arrow_rounded),
            ),
            FloatingActionButton(
              onPressed: () async {
                // reset graph
                await widget.args.mControlCharacteristic.write([102]);
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
        color: Colors.blue,
        dataSource: chartData,
        animationDuration: 0,
        xValueMapper: (data, _) => 0,
        yValueMapper: (data, _) => data.y1,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
          textStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        onRendererCreated: (ChartSeriesController controller) => _graphDataController = controller,
      ),
    ];
  }

  Future<void> _getData(List<int> dataList) async {
    final _resultWeightMeasurement = 1;
    double _avgWeightOf8Rec = 0;
    int _avgTimeof8Rec = 0;
    int _countOf8Rec = 0;
    if (dataList.isNotEmpty && dataList[0] == _resultWeightMeasurement) {
      for (int x = 2; x < dataList.length; x += 8) {
        _countOf8Rec++;
        _avgWeightOf8Rec +=
            Uint8List.fromList(dataList.getRange(x, x + 4).toList()).buffer.asByteData().getFloat32(0, Endian.little);
        _avgTimeof8Rec += Uint8List.fromList(dataList.getRange(x + 4, x + 4 + 4).toList())
            .buffer
            .asByteData()
            .getUint32(0, Endian.little);
        if (_countOf8Rec == 8) {
          chartData.insert(
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
      /*StackedColumnSeries<ChartData, String>(
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
      ),*/
    ];
  }

* */

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
              onPressed: () {},
              heroTag: 'tag-stop-btn',
              child: Icon(Icons.play_arrow_rounded),
            ),
            FloatingActionButton(
              onPressed: () {},
              heroTag: 'tag-play-btn',
              child: Icon(Icons.stop_rounded),
            ),
            FloatingActionButton(
              onPressed: () {},
              heroTag: 'tag-reset-btn',
              child: Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  List<StackedColumnSeries<ChartData, String>> _getStackedColumnSeries() {
    final List<ChartData> chartData = <ChartData>[ChartData(y1: 2, y2: 1)];

    return <StackedColumnSeries<ChartData, String>>[
      StackedColumnSeries<ChartData, String>(
        width: 0.9,
        color: Colors.blue,
        dataSource: chartData,
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
        dataSource: chartData,
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
}

class ChartData {
  ChartData({this.y1, this.y2});

  final double y1;
  final double y2;
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
* */

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      enableSideBySideSeriesPlacement: false,
      primaryXAxis: CategoryAxis(isVisible: false),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 100,
        interval: 10,
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      series: _getSeries(),
    );
  }

  List<ColumnSeries<ChartData, String>> _getSeries() {
    return <ColumnSeries<ChartData, String>>[
      _columnSeries(ChartData(x: '', y: 80.5), <Color>[Colors.green[600]]),
      _columnSeries(
        ChartData(x: '', y: 60.1),
        <Color>[Colors.blue, Colors.blue[200]],
        isPrimary: true,
      ),
    ];
  }

  ColumnSeries<ChartData, String> _columnSeries(ChartData data, List<Color> colors, {bool isPrimary: false}) {
    return ColumnSeries<ChartData, String>(
      width: 0.9,
      gradient: isPrimary
          ? LinearGradient(
              colors: colors,
              stops: <double>[0.3, 0.9],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )
          : null,
      color: isPrimary ? null : colors.first,
      borderRadius: isPrimary ? null : BorderRadius.circular(10.0),
      dataSource: [data],
      xValueMapper: (ChartData value, _) => value.x,
      yValueMapper: (ChartData value, _) => value.y,
      dataLabelSettings: DataLabelSettings(
        isVisible: true,
        labelAlignment: ChartDataLabelAlignment.top,
        textStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ChartData {
  ChartData({this.x, this.y});

  final String x;
  final double y;
}

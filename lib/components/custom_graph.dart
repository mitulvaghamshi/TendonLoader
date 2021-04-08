import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/utils/modal/chart_data.dart';

class CustomGraph extends StatelessWidget {
  const CustomGraph({Key key, this.isLive = false, this.series}) : super(key: key);

  final bool isLive;
  final List<ChartSeries<ChartData, int>> Function() series;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SfCartesianChart(
        series: series(),
        plotAreaBorderWidth: 0,
        primaryXAxis: isLive ? CategoryAxis(minimum: 0, maximum: 0, isVisible: false) : NumericAxis(minimum: 0, isVisible: false),
        primaryYAxis: NumericAxis(
          maximum: 30,
          labelFormat: '{value} kg',
          axisLine: AxisLine(width: 0),
          majorGridLines: MajorGridLines(color: Theme.of(context).accentColor),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

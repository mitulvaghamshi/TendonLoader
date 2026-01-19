import 'package:flutter/material.dart';
import 'package:server/models/chartdata.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

@immutable
class ExerciseDataGraph extends StatelessWidget {
  const ExerciseDataGraph({
    super.key,
    required this.tagetLoad,
    required this.items,
  });

  final double tagetLoad;
  final Iterable<ChartData> items;

  @override
  Widget build(BuildContext context) => SfCartesianChart(
    tooltipBehavior: TooltipBehavior(enable: true, header: 'Time/Load'),
    primaryXAxis: const NumericAxis(
      interval: 1,
      labelFormat: '{value} sec',
      edgeLabelPlacement: .shift,
    ),
    primaryYAxis: const NumericAxis(interval: 1, labelFormat: '{value} kg'),
    series: <LineSeries<ChartData, double>>[
      LineSeries(
        color: Colors.green,
        animationDuration: 7000,
        xValueMapper: (data, _) => data.time,
        yValueMapper: (data, _) => data.load,
        dataSource: items.toList(),
      ),
      LineSeries(
        color: Colors.orange,
        animationDuration: 0,
        xValueMapper: (data, _) => data.time,
        yValueMapper: (data, _) => data.load,
        dataSource: [
          ChartData(load: tagetLoad),
          ChartData(time: items.last.time, load: tagetLoad),
        ],
      ),
    ],
  );
}

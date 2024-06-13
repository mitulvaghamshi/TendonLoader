import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/models/chartdata.dart';

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
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(enable: true, header: 'Time/Load'),
      primaryXAxis: const NumericAxis(
        interval: 1,
        labelFormat: '{value} sec',
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(
        interval: 1,
        labelFormat: '{value} kg',
      ),
      series: <LineSeries<ChartData, double>>[
        LineSeries<ChartData, double>(
          color: Colors.green,
          animationDuration: 7000,
          xValueMapper: (data, _) => data.time,
          yValueMapper: (data, _) => data.load,
          dataSource: items.toList(),
        ),
        LineSeries<ChartData, double>(
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
}

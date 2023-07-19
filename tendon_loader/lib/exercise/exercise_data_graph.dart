import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/models/chartdata.dart';

@immutable
final class ExerciseDataGraph extends StatelessWidget {
  const ExerciseDataGraph(
      {super.key, required this.tagetLoad, required this.items});

  final double tagetLoad;
  final Iterable<ChartData> items;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      tooltipBehavior: TooltipBehavior(enable: true, header: 'Load/Time'),
      primaryXAxis: NumericAxis(
        interval: 1,
        labelFormat: '{value} sec',
        enableAutoIntervalOnZooming: true,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        interval: 1,
        labelFormat: '{value} kg',
        // enableAutoIntervalOnZooming: true,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        maximumZoomLevel: 0.1,
        enableSelectionZooming: true,
        enableMouseWheelZooming: true,
      ),
      series: [
        LineSeries<ChartData, double>(
          width: 2,
          animationDuration: 7000,
          color: Colors.green,
          xValueMapper: (data, _) => data.time,
          yValueMapper: (data, _) => data.load,
          dataSource: items.toList(),
        ),
        LineSeries<ChartData, double>(
          width: 2,
          animationDuration: 0,
          color: Colors.orange,
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

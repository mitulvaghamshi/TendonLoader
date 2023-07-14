import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/common/widgets/no_result_widget.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/models/prescription.dart';

@immutable
class DataGraph extends StatelessWidget {
  const DataGraph({super.key});

  @override
  Widget build(BuildContext context) {
    const export = Exercise.empty();
    //  AppScope.of(context).userState.excercise;
    final load = export.mvcValue != null
        ? export.mvcValue!
        : const Prescription.empty().targetLoad;
    final tooltip = export.mvcValue != null ? 'MVC' : 'Measurement';
    final list = export.data.toList();
    if (list.isEmpty) return const NoResultWidget();
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      tooltipBehavior: TooltipBehavior(enable: true, header: tooltip),
      primaryXAxis: NumericAxis(
        interval: 1,
        labelFormat: '{value} sec',
        enableAutoIntervalOnZooming: true,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        interval: 1,
        labelFormat: '{value} kg',
        enableAutoIntervalOnZooming: true,
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        maximumZoomLevel: 0.1,
        enableSelectionZooming: true,
        enableMouseWheelZooming: true,
      ),
      series: <ChartSeries<ChartData, double>>[
        LineSeries<ChartData, double>(
          width: 2,
          animationDuration: 7000,
          color: const Color(0xff3ddc85),
          xValueMapper: (data, _) => data.time,
          yValueMapper: (data, _) => data.load,
          dataSource: list,
        ),
        LineSeries<ChartData, double>(
          width: 2,
          animationDuration: 0,
          color: const Color(0xffff534d),
          xValueMapper: (data, _) => data.time,
          yValueMapper: (data, _) => data.load,
          dataSource: <ChartData>[
            ChartData(load: load),
            ChartData(time: list.last.time, load: load),
          ],
        ),
      ],
    );
  }
}

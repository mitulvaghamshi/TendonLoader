import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/common/models/chartdata.dart';
import 'package:tendon_loader/common/models/export.dart';
import 'package:tendon_loader/common/widgets/no_result_widget.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';

@immutable
class DataGraph extends StatelessWidget {
  const DataGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final Export export = AppState.of(context).getSelectedExport();
    final double load =
        export.isMVC ? export.mvcValue! : export.prescription!.targetLoad;
    final String tooltip = export.isMVC ? 'MVC' : 'Measurement';
    final List<ChartData>? list = export.exportData?.toList();
    if (list == null || list.isEmpty) return const NoResultWidget();
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

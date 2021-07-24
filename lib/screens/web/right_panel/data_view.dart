import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/themes.dart';

class DataView extends StatelessWidget {
  const DataView({Key? key, required this.export}) : super(key: key);

  final Export export;

  @override
  Widget build(BuildContext context) {
    final double _targetLine = export.isMVC ? export.mvcValue! : export.prescription!.targetLoad;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      selectionType: SelectionType.point,
      tooltipBehavior: TooltipBehavior(enable: true, header: export.isMVC ? 'MVC' : 'Measurement'),
      primaryXAxis: NumericAxis(
        interval: 1,
        labelFormat: '{value} s',
        enableAutoIntervalOnZooming: true,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        interval: 1,
        labelFormat: '{value} kg',
        enableAutoIntervalOnZooming: true,
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: Theme.of(context).accentColor),
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
          color: colorGoogleGreen,
          animationDuration: 5000,
          dataSource: export.exportData!,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.load,
        ),
        LineSeries<ChartData, double>(
          width: 2,
          color: colorRed400,
          animationDuration: 2000,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.load,
          dataSource: <ChartData>[
            ChartData(load: _targetLine),
            ChartData(time: export.exportData!.last.time, load: _targetLine),
          ],
        ),
      ],
    );
  }
}

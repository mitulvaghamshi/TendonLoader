import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/custom/app_frame.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/web/common.dart';

@immutable
class DataView extends StatelessWidget {
  const DataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.fromLTRB(8, 16, 16, 16),
      child: ValueListenableBuilder<Export?>(
        valueListenable: exportNotifier,
        builder: (BuildContext context, Export? value, Widget? child) {
          if (value == null || value.exportData!.isEmpty) return child!;
          final double _targetLine =
              value.isMVC ? value.mvcValue! : value.prescription!.targetLoad;
          return SfCartesianChart(
            plotAreaBorderWidth: 0,
            tooltipBehavior: TooltipBehavior(
              enable: true,
              header: value.isMVC ? 'MVC' : 'Measurement',
            ),
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
              majorGridLines: MajorGridLines(
                color: Theme.of(context).accentColor,
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
                color: colorMidGreen,
                animationDuration: 7000,
                dataSource: value.exportData!,
                xValueMapper: (ChartData data, _) => data.time,
                yValueMapper: (ChartData data, _) => data.load,
              ),
              LineSeries<ChartData, double>(
                width: 2,
                color: colorErrorRed,
                animationDuration: 0,
                xValueMapper: (ChartData data, _) => data.time,
                yValueMapper: (ChartData data, _) => data.load,
                dataSource: <ChartData>[
                  ChartData(load: _targetLine),
                  ChartData(
                    time: value.exportData!.last.time,
                    load: _targetLine,
                  ),
                ],
              ),
            ],
          );
        },
        child: const Center(child: CustomImage()),
      ),
    );
  }
}

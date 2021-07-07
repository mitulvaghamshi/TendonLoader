import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/modal/chartdata.dart';

class CustomGraph extends StatelessWidget {
  const CustomGraph({Key? key, this.graphData, this.lineData, this.lineCtrl, this.graphCtrl}) : super(key: key);

  final List<ChartData>? lineData;
  final List<ChartData?>? graphData;
  final void Function(ChartSeriesController)? lineCtrl;
  final void Function(ChartSeriesController)? graphCtrl;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: lineData != null
              ? NumericAxis(minimum: 0, isVisible: false)
              : CategoryAxis(minimum: 0, maximum: 0, isVisible: false),
          primaryYAxis: NumericAxis(
            labelFormat: '{value} kg',
            axisLine: const AxisLine(width: 0),
            maximum: AppStateScope.of(context).settingsState!.graphSize,
            majorGridLines: MajorGridLines(color: Theme.of(context).accentColor),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          series: <ChartSeries<ChartData?, int>>[
            ColumnSeries<ChartData?, int>(
              width: 0.9,
              borderWidth: 1,
              animationDuration: 0,
              dataSource: graphData!,
              color: googleGreen,
              onRendererCreated: graphCtrl,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                showZeroValue: false,
                textStyle: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
                labelAlignment: ChartDataLabelAlignment.bottom,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              xValueMapper: (ChartData? data, _) => 1,
              yValueMapper: (ChartData? data, _) => data!.load,
            ),
            if (lineData != null)
              LineSeries<ChartData, int>(
                width: 5,
                color: red400,
                animationDuration: 0,
                dataSource: lineData!,
                onRendererCreated: lineCtrl,
                yValueMapper: (ChartData data, _) => data.load,
                xValueMapper: (ChartData data, _) => data.time!.toInt(),
              ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart' show BorderRadius, BuildContext, Colors, EdgeInsets, Expanded, FontWeight, Key, Padding, Radius, StatelessWidget, TextStyle, Theme, Widget;
import 'package:syncfusion_flutter_charts/charts.dart' show AxisLine, CategoryAxis, ChartDataLabelAlignment, ChartSeries, ChartSeriesController, ColumnSeries, DataLabelSettings, LineSeries, MajorGridLines, NumericAxis, SfCartesianChart;
import 'package:tendon_support_module/modal/chartdata.dart';

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
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: lineData != null
              ? NumericAxis(minimum: 0, isVisible: false)
              : CategoryAxis(minimum: 0, maximum: 0, isVisible: false),
          primaryYAxis: NumericAxis(
            maximum: 30,
            labelFormat: '{value} kg',
            axisLine: const AxisLine(width: 0),
            majorGridLines: MajorGridLines(color: Theme.of(context).accentColor),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          series: <ChartSeries<ChartData?, int>>[
            ColumnSeries<ChartData?, int>(
              width: 0.9,
              borderWidth: 1,
              color: Colors.blue,
              animationDuration: 0,
              dataSource: graphData!,
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
                color: Colors.red,
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

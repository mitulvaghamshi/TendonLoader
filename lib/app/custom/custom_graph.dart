import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';

class CustomGraph extends StatelessWidget {
  const CustomGraph({Key key, this.showLine = false}) : super(key: key);

  final bool showLine;
  static ChartSeriesController _lineCtrl;
  static ChartSeriesController _graphCtrl;
  static final List<ChartData> _graphData = <ChartData>[];
  static final List<ChartData> _lineData = <ChartData>[ChartData(), ChartData(time: 2)];

  static void updateGraph(ChartData data) {
    _graphData.insert(0, data);
    if (_graphCtrl != null) _graphCtrl.updateDataSource(updatedDataIndex: 0);
  }

  static void updateLine(double value) {
    _lineData.insertAll(0, <ChartData>[ChartData(load: value), ChartData(time: 2, load: value)]);
    if (_lineCtrl != null) _lineCtrl?.updateDataSource(updatedDataIndexes: <int>[0, 1]);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: showLine
            ? NumericAxis(minimum: 0, isVisible: false)
            : CategoryAxis(minimum: 0, maximum: 0, isVisible: false),
        primaryYAxis: NumericAxis(
          maximum: 30,
          labelFormat: '{value} kg',
          axisLine: const AxisLine(width: 0),
          majorGridLines: MajorGridLines(color: Theme.of(context).accentColor),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        series: <ChartSeries<ChartData, int>>[
          ColumnSeries<ChartData, int>(
            width: 0.9,
            borderWidth: 1,
            color: Colors.blue,
            animationDuration: 0,
            dataSource: _graphData,
            borderColor: Colors.black,
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
            xValueMapper: (ChartData data, _) => 1,
            yValueMapper: (ChartData data, _) => data.load,
            onRendererCreated: (ChartSeriesController ctrl) => _graphCtrl = ctrl,
          ),
          if (showLine)
            LineSeries<ChartData, int>(
              width: 5,
              color: Colors.red,
              animationDuration: 0,
              dataSource: _lineData,
              yValueMapper: (ChartData data, _) => data.load,
              xValueMapper: (ChartData data, _) => data.time.toInt(),
              onRendererCreated: (ChartSeriesController ctrl) => _lineCtrl = ctrl,
            ),
        ],
      ),
    );
  }
}

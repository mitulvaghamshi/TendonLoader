import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/components/app_frame.dart';
import 'package:tendon_loader/utils/modal/chart_data.dart';

class LineGraph extends StatelessWidget {
  const LineGraph({Key key, this.data}) : super(key: key);

  final List<ChartData> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Current file name')),
      body: AppFrame(
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          margin: const EdgeInsets.all(20),
          primaryXAxis: NumericAxis(labelFormat: '{value} s', majorGridLines: const MajorGridLines(width: 0)),
          primaryYAxis: NumericAxis(
            labelFormat: '{value} kg',
            axisLine: const AxisLine(width: 0),
            anchorRangeToVisiblePoints: true,
            majorTickLines: const MajorTickLines(size: 0),
            majorGridLines: MajorGridLines(color: Theme.of(context).accentColor),
          ),
          zoomPanBehavior: ZoomPanBehavior(
            enablePanning: true,
            enablePinching: true,
            zoomMode: ZoomMode.x,
            enableMouseWheelZooming: true,
          ),
          series: <AreaSeries<ChartData, double>>[
            AreaSeries<ChartData, double>(
              borderWidth: 1,
              dataSource: data,
              color: Colors.blue,
              animationDuration: 0,
              borderColor: Colors.black,
              xValueMapper: (ChartData data, _) => data.time,
              yValueMapper: (ChartData data, _) => data.load,
            ),
          ],
        ),
      ),
    );
  }
}

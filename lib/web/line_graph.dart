import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/prescription.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';

class LineGraph extends StatelessWidget {
  const LineGraph({Key key, this.data, this.info, this.prescription, this.name}) : super(key: key);

  final List<ChartData> data;
  final Prescription prescription;
  final SessionInfo info;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: AppFrame(
        child: Column(
          children: <Widget>[
            _buildTable(context),
            const SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: NumericAxis(
                  labelFormat: '{value} s',
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  labelFormat: '{value} kg',
                  anchorRangeToVisiblePoints: true,
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: MajorGridLines(color: Theme.of(context).accentColor),
                ),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                  enablePinching: true,
                  zoomMode: ZoomMode.x,
                  enableMouseWheelZooming: true,
                ),
                series: <ChartSeries<ChartData, double>>[
                  AreaSeries<ChartData, double>(
                    borderWidth: 1,
                    dataSource: data,
                    color: Colors.blue,
                    animationDuration: 0,
                    borderColor: Colors.black,
                    xValueMapper: (ChartData data, _) => data.time,
                    yValueMapper: (ChartData data, _) => data.load,
                  ),
                  if (prescription != null)
                    LineSeries<ChartData, double>(
                      width: 5,
                      color: Colors.red,
                      animationDuration: 0,
                      yValueMapper: (ChartData data, _) => data.load,
                      xValueMapper: (ChartData data, _) => data.time,
                      dataSource: <ChartData>[
                        ChartData(load: prescription.targetLoad),
                        ChartData(time: data.last.time, load: prescription.targetLoad)
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableCell _cell(String text) {
    return TableCell(child: Padding(padding: const EdgeInsets.all(8), child: Text(text, style: const TextStyle(fontSize: 18))));
  }

  Table _buildTable(BuildContext context) {
    return Table(
      border: TableBorder.symmetric(outside: BorderSide(width: 1, color: Theme.of(context).accentColor)),
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            _cell('Date: ${info.exportDate}'),
            if (prescription != null) _cell('MVC: ${prescription.lastMVC},    Target Load: ${prescription.targetLoad}'),
            _cell('Type: ${info.exportType}'),
          ],
        ),
        TableRow(
          children: <Widget>[
            _cell('Time: ${info.exportTime}'),
            if (prescription != null) _cell('Hold: ${prescription.holdTime},    Rest: ${prescription.restTime}'),
            _cell('User: ${info.userId}'),
          ],
        ),
        TableRow(
          children: <Widget>[
            _cell('Status: ${info.dataStatus}'),
            if (prescription != null) _cell('Sets: ${prescription.sets},    Reps: ${prescription.reps}'),
            _cell('Device: ${info.progressorId}'),
          ],
        ),
      ],
    );
  }
}

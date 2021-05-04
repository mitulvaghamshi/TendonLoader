import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/prescription.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';

class LineGraph extends StatelessWidget {
  const LineGraph({Key key, this.data, this.sessionInfo, this.prescription, this.name}) : super(key: key);

  final String name;
  final SessionInfo sessionInfo;
  final List<ChartData> data;
  final Prescription prescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: AppFrame(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: <Widget>[
                      sessionInfo.toTable(),
                      if (prescription != null) prescription.toTable(),
                    ]),
                  ),
                  Expanded(
                    child: SfCartesianChart(
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        header: prescription != null ? 'Peak value' : 'MVC',
                      ),
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
                          gradient: LinearGradient(
                            end: Alignment.topCenter,
                            stops: const <double>[0.2, 0.6],
                            begin: Alignment.bottomCenter,
                            colors: prescription != null
                                ? const <Color>[
                                    Color.fromRGBO(269, 210, 255, 1),
                                    Color.fromRGBO(143, 236, 154, 1),
                                  ]
                                : const <Color>[
                                    Color.fromRGBO(140, 108, 245, 1),
                                    Color.fromRGBO(125, 185, 253, 1),
                                  ],
                          ),
                        ),
                        if (prescription != null)
                          LineSeries<ChartData, double>(
                            width: 2,
                            color: Colors.red,
                            animationDuration: 0,
                            yValueMapper: (ChartData data, _) => data.load,
                            xValueMapper: (ChartData data, _) => data.time,
                            dataSource: <ChartData>[
                              ChartData(load: prescription.targetLoad),
                              ChartData(time: data.last.time, load: prescription.targetLoad),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            if (MediaQuery.of(context).size.width > Sizes.SIZE_MIN_WIDTH)
              LimitedBox(
                maxWidth: 180,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (_, int index) {
                    return ListTile(
                      tileColor: index.isEven ? Colors.grey.withOpacity(0.3) : null,
                      leading: Text('${index + 1})', style: const TextStyle(fontSize: 14)),
                      title: Text('${data[index].time}', style: const TextStyle(fontSize: 14)),
                      trailing: Text('${data[index].load}', style: const TextStyle(fontSize: 14)),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

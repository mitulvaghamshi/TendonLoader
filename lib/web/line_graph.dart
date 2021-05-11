import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/prescription.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';

class LineGraph extends StatefulWidget {
  const LineGraph({Key key, this.data, this.sessionInfo, this.prescription}) : super(key: key);

  final List<ChartData> data;
  final SessionInfo sessionInfo;
  final Prescription prescription;

  @override
  _LineGraphState createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final bool _useDrawer = MediaQuery.of(context).size.width < Sizes.SIZE_MIN_WIDTH;
    const TextStyle ts14 = TextStyle(fontSize: 14);
    final LimitedBox _dataTable = LimitedBox(
      maxWidth: 200,
      child: Scrollbar(
        thickness: 15,
        isAlwaysShown: true,
        controller: _scrollController,
        child: ListView.builder(
          itemExtent: 50,
          controller: _scrollController,
          itemCount: widget.data.length,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (_, int index) => ListTile(
            leading: Text('${index + 1})', style: ts14),
            title: Text('${widget.data[index].time}', style: ts14),
            trailing: Text('${widget.data[index].load}', style: ts14),
            tileColor: index.isEven ? Colors.grey.withOpacity(0.3) : null,
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text(widget.sessionInfo.fileName)),
      endDrawer: _useDrawer ? Drawer(child: _dataTable) : null,
      body: AppFrame(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: <Widget>[widget.sessionInfo.toTable(), widget.prescription?.toTable()]),
                  ),
                  Expanded(
                    child: SfCartesianChart(
                      plotAreaBorderWidth: 0,
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        animationDuration: 0,
                        header: widget.prescription != null ? 'Measurement' : 'MVC',
                      ),
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
                          dataSource: widget.data,
                          animationDuration: 0,
                          borderColor: Colors.black,
                          xValueMapper: (ChartData data, _) => data.time,
                          yValueMapper: (ChartData data, _) => data.load,
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: <double>[0.2, 0.8],
                            colors: <Color>[Colors.blue, Colors.indigo],
                          ),
                        ),
                        if (widget.prescription != null)
                          LineSeries<ChartData, double>(
                            width: 2,
                            color: Colors.red,
                            animationDuration: 0,
                            yValueMapper: (ChartData data, _) => data.load,
                            xValueMapper: (ChartData data, _) => data.time,
                            dataSource: <ChartData>[
                              ChartData(load: widget.prescription.targetLoad),
                              ChartData(time: widget.data.last.time, load: widget.prescription.targetLoad),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!_useDrawer) _dataTable
          ],
        ),
      ),
    );
  }
}

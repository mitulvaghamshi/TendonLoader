import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/custom/custom_image.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/web/handler/item_click_controller.dart';
import 'package:tendon_loader/web/handler/item_click_handler.dart';

class LineGraph extends StatefulWidget {
  const LineGraph({Key key}) : super(key: key);

  @override
  _LineGraphState createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  final ScrollController _scrollController = ScrollController();
  final TextStyle ts14 = const TextStyle(fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: StreamBuilder<ItemClickHandler>(
        stream: ItemClickController.stream,
        builder: (_, AsyncSnapshot<ItemClickHandler> snapshot) {
          if (!snapshot.hasData) return const Expanded(child: Center(child: CustomImage(isBg: true)));
          return Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: <Widget>[
                        snapshot.data.sessionInfo.toTable(),
                        snapshot.data.prescription?.toTable(),
                      ]),
                    ),
                    Expanded(
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          animationDuration: 0,
                          header: snapshot.data.prescription != null ? 'Measurement' : 'MVC',
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
                            animationDuration: 0,
                            borderColor: Colors.black,
                            dataSource: snapshot.data.dataList,
                            xValueMapper: (ChartData data, _) => data.time,
                            yValueMapper: (ChartData data, _) => data.load,
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: <double>[0.2, 0.8],
                              colors: <Color>[Colors.blue, Colors.indigo],
                            ),
                          ),
                          if (snapshot.data.prescription != null)
                            LineSeries<ChartData, double>(
                              width: 2,
                              color: Colors.red,
                              animationDuration: 0,
                              yValueMapper: (ChartData data, _) => data.load,
                              xValueMapper: (ChartData data, _) => data.time,
                              dataSource: <ChartData>[
                                ChartData(load: snapshot.data.prescription.targetLoad),
                                ChartData(
                                  time: snapshot.data.dataList.last.time,
                                  load: snapshot.data.prescription.targetLoad,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (snapshot.data.prescription != null)
                LimitedBox(
                  maxWidth: 200,
                  child: Scrollbar(
                    thickness: 15,
                    isAlwaysShown: true,
                    controller: _scrollController,
                    child: ListView.builder(
                      itemExtent: 50,
                      controller: _scrollController,
                      itemCount: snapshot.data.dataList.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (_, int index) => ListTile(
                        leading: Text('${index + 1})', style: ts14),
                        title: Text('${snapshot.data.dataList[index].time}', style: ts14),
                        trailing: Text('${snapshot.data.dataList[index].load}', style: ts14),
                        tileColor: index.isEven ? Colors.grey.withOpacity(0.3) : null,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

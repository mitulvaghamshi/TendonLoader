import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/custom/custom_image.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/web/handler/item_click_controller.dart';
import 'package:tendon_loader/web/handler/item_click_handler.dart';

class RightPanel extends StatefulWidget {
  const RightPanel({Key key}) : super(key: key);

  @override
  _RightPanelState createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  final ScrollController _scrollController = ScrollController();
  final TextStyle ts14 = const TextStyle(
    fontSize: 16,
    wordSpacing: 20,
    letterSpacing: 1.5,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: StreamBuilder<ItemClickHandler>(
        stream: ItemClickController.stream,
        builder: (_, AsyncSnapshot<ItemClickHandler> snapshot) {
          if (!snapshot.hasData) return const Center(child: CustomImage(isBg: true));
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'No. Time Load',
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20, wordSpacing: 20),
                      ),
                      const Divider(color: Colors.black, thickness: 3),
                      Expanded(
                        child: Scrollbar(
                          thickness: 15,
                          isAlwaysShown: true,
                          controller: _scrollController,
                          child: ListView.separated(
                            separatorBuilder: (_, int index) => Divider(
                              color: index % 10 == 9 ? Colors.red : Colors.grey,
                              thickness: 1,
                            ),
                            controller: _scrollController,
                            itemCount: snapshot.data.dataList.length,
                            padding: const EdgeInsets.only(right: 20),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (_, int index) {
                              final String i = '${index + 1}'.padLeft(3, '  ');
                              final String t = snapshot.data.dataList[index].time.toStringAsFixed(1).padRight(4);
                              final String l = snapshot.data.dataList[index].load.toStringAsFixed(2).padRight(4);
                              return Text('$i. $t $l', style: ts14);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

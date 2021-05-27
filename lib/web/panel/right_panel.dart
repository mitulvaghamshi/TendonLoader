import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/custom/custom_image.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/data_model.dart';
import 'package:tendon_loader/web/handler/click_handler.dart';

class RightPanel extends StatefulWidget {
  const RightPanel({Key? key}) : super(key: key);

  @override
  _RightPanelState createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  final ScrollController _scrollController = ScrollController(keepScrollOffset: false);
  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: StreamBuilder<DataModel>(
        stream: ClickHandler.stream,
        builder: (_, AsyncSnapshot<DataModel> snapshot) {
          if (!snapshot.hasData) return const Center(child: CustomImage());
          final DataModel _model = snapshot.data!;
          final bool _isExercise = _model.prescription != null;
          return Row(children: <Widget>[
            Expanded(
              child: Column(children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: <Widget>[
                    _model.sessionInfo!.toTable(),
                    if (_isExercise) _model.prescription!.toTable(),
                  ]),
                ),
                Expanded(
                  child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    selectionType: SelectionType.point,
                    tooltipBehavior: TooltipBehavior(enable: true, header: _isExercise ? 'Measurement' : 'MVC'),
                    primaryXAxis: NumericAxis(
                      labelFormat: '{value} s',
                      anchorRangeToVisiblePoints: true,
                      enableAutoIntervalOnZooming: true,
                      visibleMaximum: 5,
                      // visibleMaximum: _isExercise ? 50 : 5,
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      interval: 1,
                      labelFormat: '{value} kg',
                      anchorRangeToVisiblePoints: true,
                      enableAutoIntervalOnZooming: true,
                      majorTickLines: const MajorTickLines(size: 0),
                      majorGridLines: MajorGridLines(color: Theme.of(context).accentColor),
                    ),
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePanning: true,
                      enablePinching: true,
                      enableSelectionZooming: true,
                      enableMouseWheelZooming: true,
                    ),
                    series: <ChartSeries<ChartData, double>>[
                      LineSeries<ChartData, double>(
                        width: 2,
                        color: Colors.blue,
                        animationDuration: 3000,
                        dataSource: _model.dataList!,
                        xValueMapper: (ChartData data, _) => data.time,
                        yValueMapper: (ChartData data, _) => data.load,
                      ),
                      if (_isExercise)
                        LineSeries<ChartData, double>(
                          width: 2,
                          color: Colors.red,
                          animationDuration: 1000,
                          xValueMapper: (ChartData data, _) => data.time,
                          yValueMapper: (ChartData data, _) => data.load,
                          dataSource: <ChartData>[
                            ChartData(load: _model.prescription!.targetLoad),
                            ChartData(time: _model.dataList!.last.time, load: _model.prescription!.targetLoad),
                          ],
                        ),
                    ],
                  ),
                ),
              ]),
            ),
            LimitedBox(
              maxWidth: 250,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                const Text(
                  'No. Time Load',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20, wordSpacing: 25),
                ),
                const Divider(color: Colors.black, thickness: 3),
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: _model.dataList!.length,
                    padding: const EdgeInsets.only(left: 5, right: 20),
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (_, int index) => Divider(
                      thickness: 1,
                      color: index % 10 == 9 ? Colors.red : Colors.grey,
                    ),
                    itemBuilder: (_, int index) {
                      final String i = '${index + 1}'.padLeft(3, '  ');
                      final String t = _model.dataList![index].time!.toStringAsFixed(1).padRight(4);
                      final String l = _model.dataList![index].load!.toStringAsFixed(2).padRight(4);
                      return Text(
                        '$i. $t $l',
                        style: const TextStyle(
                          fontSize: 16,
                          wordSpacing: 20,
                          letterSpacing: 1.5,
                          fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ]);
        },
      ),
    );
  }
}

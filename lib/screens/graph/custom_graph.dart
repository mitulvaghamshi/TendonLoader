import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/app_frame.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/screens/exercise/exercise_handler.dart';
import 'package:tendon_loader/screens/graph/graph_handler.dart';
import 'package:tendon_loader/screens/livedata/livedata_handler.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomGraph extends StatefulWidget {
  const CustomGraph({
    Key? key,
    required this.title,
    required this.handler,
    required this.builder,
  }) : super(key: key);

  final String title;
  final GraphHandler handler;
  final Widget Function() builder;

  @override
  _CustomGraphState createState() => _CustomGraphState();
}

class _CustomGraphState extends State<CustomGraph> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: AppFrame(
        padding: const EdgeInsets.only(bottom: 16),
        onExit: widget.handler.exit,
        child: Column(children: <Widget>[
          StreamBuilder<ChartData>(
            initialData: ChartData(),
            stream: GraphHandler.stream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              widget.handler.graphData.insert(0, snapshot.data!);
              widget.handler.graphCtrl?.updateDataSource(updatedDataIndex: 0);
              return Row(children: <Widget>[
                Expanded(
                  child: CustomButton(
                    radius: 0,
                    left: widget.builder(),
                    color: widget.handler.feedColor,
                  ),
                ),
              ]);
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: widget.handler.lineData != null
                    ? NumericAxis(minimum: 0, isVisible: false)
                    : CategoryAxis(minimum: 0, maximum: 0, isVisible: false),
                primaryYAxis: NumericAxis(
                  labelFormat: '{value} kg',
                  axisLine: const AxisLine(width: 0),
                  maximum:  settingsState.graphSize,
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: MajorGridLines(
                    color: Theme.of(context).accentColor,
                  ),
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                series: <ChartSeries<ChartData?, int>>[
                  ColumnSeries<ChartData?, int>(
                    width: 0.9,
                    color: colorIconBlue,
                    animationDuration: 0,
                    dataSource: widget.handler.graphData,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      showZeroValue: false,
                      labelAlignment: ChartDataLabelAlignment.bottom,
                      textStyle: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    xValueMapper: (ChartData? data, _) => 1,
                    yValueMapper: (ChartData? data, _) => data!.load,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    onRendererCreated: (ChartSeriesController ctrl) {
                      widget.handler.graphCtrl = ctrl;
                    },
                  ),
                  if (widget.handler is! LiveDataHandler)
                    LineSeries<ChartData, int>(
                      width: 5,
                      color: colorErrorRed,
                      animationDuration: 0,
                      dataSource: widget.handler.lineData!,
                      yValueMapper: (ChartData data, _) => data.load,
                      xValueMapper: (ChartData data, _) => data.time.toInt(),
                      onRendererCreated: (ChartSeriesController ctrl) {
                        widget.handler.lineCtrl = ctrl;
                      },
                    ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CustomButton(
                rounded: true,
                left: const Icon(Icons.play_arrow),
                onPressed: widget.handler.start,
              ),
              if (widget.handler is ExerciseHandler)
                CustomButton(
                  rounded: true,
                  left: const Icon(Icons.pause),
                  onPressed: widget.handler.pause,
                ),
              CustomButton(
                rounded: true,
                left: const Icon(Icons.stop),
                onPressed: widget.handler.stop,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

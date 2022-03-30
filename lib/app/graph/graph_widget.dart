import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/app/exercise/exercise_handler.dart';
import 'package:tendon_loader/app/graph/graph_handler.dart';
import 'package:tendon_loader/app/livedata/livedata_handler.dart';
import 'package:tendon_loader/shared/models/chartdata.dart';
import 'package:tendon_loader/shared/utils/common.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';
import 'package:tendon_loader/shared/widgets/frame_widget.dart';

class GraphWidget extends StatelessWidget {
  const GraphWidget({
    Key? key,
    required this.title,
    required this.handler,
    required this.builder,
  }) : super(key: key);

  final String title;
  final GraphHandler handler;
  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text(title)),
      body: FrameWidget(
        onExit: handler.exit,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(children: <Widget>[
            _Header(handler: handler, builder: builder),
            _BarGraph(handler: handler),
            _ButtonBar(handler: handler),
          ]),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.handler,
    required this.builder,
  }) : super(key: key);

  final GraphHandler handler;
  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChartData>(
      initialData: ChartData(),
      stream: GraphHandler.stream,
      builder: (_, AsyncSnapshot<ChartData> snapshot) {
        handler.graphData.insert(0, snapshot.data!);
        handler.graphCtrl?.updateDataSource(updatedDataIndex: 0);
        return ButtonWidget(
          color: handler.feedColor,
          left: Expanded(child: builder()),
        );
      },
    );
  }
}

class _BarGraph extends StatelessWidget {
  const _BarGraph({Key? key, required this.handler}) : super(key: key);

  final GraphHandler handler;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: handler.lineData != null
              ? NumericAxis(minimum: 0, isVisible: false)
              : CategoryAxis(minimum: 0, maximum: 0, isVisible: false),
          primaryYAxis: NumericAxis(
            labelFormat: '{value} kg',
            axisLine: const AxisLine(width: 0),
            maximum: settingsState.graphSize,
            majorTickLines: const MajorTickLines(size: 0),
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          series: <ChartSeries<ChartData?, int>>[
            ColumnSeries<ChartData?, int>(
              width: 0.9,
              animationDuration: 0,
              dataSource: handler.graphData,
              color: const Color(0xff000000),
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                showZeroValue: false,
                labelAlignment: ChartDataLabelAlignment.bottom,
                textStyle: TextStyle(
                  fontSize: 56,
                  color: Color(0xff3ddc85),
                  fontWeight: FontWeight.bold,
                ),
              ),
              xValueMapper: (ChartData? data, _) => 1,
              yValueMapper: (ChartData? data, _) => data!.load,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              onRendererCreated: (ChartSeriesController ctrl) {
                handler.graphCtrl = ctrl;
              },
            ),
            if (handler is! LiveDataHandler)
              LineSeries<ChartData, int>(
                width: 5,
                color: const Color(0xffff534d),
                animationDuration: 0,
                dataSource: handler.lineData!,
                yValueMapper: (ChartData data, _) => data.load,
                xValueMapper: (ChartData data, _) => data.time.toInt(),
                onRendererCreated: (ChartSeriesController ctrl) {
                  handler.lineCtrl = ctrl;
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ButtonBar extends StatelessWidget {
  const _ButtonBar({Key? key, required this.handler}) : super(key: key);

  final GraphHandler handler;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ButtonWidget(
          left: const Icon(Icons.play_arrow),
          onPressed: handler.start,
        ),
        if (handler is ExerciseHandler)
          ButtonWidget(
            left: const Icon(Icons.pause),
            onPressed: handler.pause,
          ),
        ButtonWidget(
          left: const Icon(Icons.stop),
          onPressed: handler.stop,
        ),
      ],
    );
  }
}

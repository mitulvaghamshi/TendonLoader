import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/handlers/exercise_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/handlers/livedata_handler.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/states/app_scope.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';

// onPopInvoked: (value) async {
//   final String key = await handler.exit();
//   // `TODO`(mitul): Fix this
//   if (key.isEmpty) Future.value(true);
//   onExit(key);
// }

@immutable
class GraphWidget extends StatelessWidget {
  const GraphWidget({
    super.key,
    required this.title,
    required this.handler,
    required this.headerBuilder,
  });

  final String title;
  final GraphHandler handler;
  final WidgetBuilder headerBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      persistentFooterButtons: [_GraphControls(handler: handler)],
      body: Column(children: [
        _GraphHeader(handler: handler, builder: headerBuilder),
        Expanded(child: _TheBarGraph(handler: handler)),
      ]),
    );
  }
}

@immutable
class _GraphHeader extends StatelessWidget {
  const _GraphHeader({required this.handler, required this.builder});

  final GraphHandler handler;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: const ChartData(),
      stream: GraphHandler.stream,
      builder: (_, snapshot) {
        handler.graphData.insert(0, snapshot.data!);
        handler.graphCtrl?.updateDataSource(updatedDataIndex: 0);
        return builder(context);
      },
    );
  }
}

@immutable
class _GraphControls extends StatelessWidget {
  const _GraphControls({required this.handler});

  final GraphHandler handler;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      RawButton.tile(
        onTap: handler.start,
        leading: const Icon(Icons.play_arrow, color: Color(0xff3ddc85)),
        child: const Text('Start'),
      ),
      if (handler is ExerciseHandler)
        RawButton.tile(
          onTap: handler.pause,
          leading: const Icon(Icons.pause, color: Color(0xFFDCC73D)),
          child: const Text('Pause'),
        ),
      RawButton.tile(
        onTap: handler.stop,
        leading: const Icon(Icons.stop, color: Color(0xffff534d)),
        child: const Text('Stop'),
      ),
    ]);
  }
}

@immutable
class _TheBarGraph extends StatelessWidget {
  const _TheBarGraph({required this.handler});

  final GraphHandler handler;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      margin: const EdgeInsets.all(16),
      primaryXAxis: handler.lineData != null
          ? const NumericAxis(minimum: 0, isVisible: false)
          : const CategoryAxis(minimum: 0, maximum: 0, isVisible: false),
      primaryYAxis: NumericAxis(
        interval: 2,
        labelFormat: '{value} kg',
        maximum: AppScope.of(context).settings.graphScale,
      ),
      series: <CartesianSeries<ChartData, int>>[
        ColumnSeries<ChartData, int>(
          width: 0.9,
          animationDuration: 0,
          dataSource: handler.graphData,
          color: const Color(0xff000000),
          xValueMapper: (data, _) => 1,
          yValueMapper: (data, _) => data.load,
          onRendererCreated: (ctrl) => handler.graphCtrl = ctrl,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
        ),
        if (handler is! LiveDataHandler)
          LineSeries<ChartData, int>(
            width: 5,
            color: const Color(0xffff534d),
            animationDuration: 0,
            dataSource: handler.lineData,
            yValueMapper: (data, _) => data.load,
            xValueMapper: (data, _) => data.time.toInt(),
            onRendererCreated: (ctrl) => handler.lineCtrl = ctrl,
          ),
      ],
    );
  }
}

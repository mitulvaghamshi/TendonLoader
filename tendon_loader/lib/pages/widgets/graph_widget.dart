import 'package:api_server/api_server.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/handler/exercise_handler.dart';
import 'package:tendon_loader/handler/graph_handler.dart';
import 'package:tendon_loader/handler/livedata_handler.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';
import 'package:tendon_loader/state/app_scope.dart';
import 'package:tendon_loader/state/app_state.dart';

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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    persistentFooterButtons: [_GraphControls(handler: handler)],
    body: Column(
      children: [
        _GraphHeader(handler: handler, builder: headerBuilder),
        Expanded(child: _TheBarGraph(handler: handler)),
      ],
    ),
  );
}

@immutable
class _GraphHeader extends StatelessWidget {
  const _GraphHeader({required this.handler, required this.builder});

  final GraphHandler handler;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => StreamBuilder(
    initialData: const ChartData(),
    stream: GraphHandler.stream,
    builder: (_, snapshot) {
      handler.graphData.insert(0, snapshot.requireData);
      handler.graphCtrl?.updateDataSource(updatedDataIndex: 0);
      return builder(context);
    },
  );
}

@immutable
class _GraphControls extends StatelessWidget {
  const _GraphControls({required this.handler});

  final GraphHandler handler;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: .spaceEvenly,
    children: [
      ButtonFactory.tile(
        onTap: handler.start,
        leading: const Icon(Icons.play_arrow, color: Color(0xff3ddc85)),
        child: const Text('Start'),
      ),
      if (handler is ExerciseHandler)
        ButtonFactory.tile(
          onTap: handler.pause,
          leading: const Icon(Icons.pause, color: Color(0xFFDCC73D)),
          child: const Text('Pause'),
        ),
      ButtonFactory.tile(
        onTap: handler.stop,
        leading: const Icon(Icons.stop, color: Color(0xffff534d)),
        child: const Text('Stop'),
      ),
    ],
  );
}

@immutable
class _TheBarGraph extends StatelessWidget {
  const _TheBarGraph({required this.handler});

  final GraphHandler handler;

  @override
  Widget build(BuildContext context) => SfCartesianChart(
    margin: const .all(16),
    primaryXAxis: handler.lineData != null
        ? const NumericAxis(minimum: 0, isVisible: false)
        : const CategoryAxis(minimum: 0, maximum: 0, isVisible: false),
    primaryYAxis: NumericAxis(
      interval: 2,
      labelFormat: '{value} kg',
      maximum: context.read<AppState>().settings.graphScale,
    ),
    series: <CartesianSeries<ChartData, int>>[
      ColumnSeries(
        width: 0.9,
        animationDuration: 0,
        dataSource: handler.graphData,
        color: const Color(0xff000000),
        xValueMapper: (data, _) => 1,
        yValueMapper: (data, _) => data.load,
        onRendererCreated: (ctrl) => handler.graphCtrl = ctrl,
        borderRadius: const .vertical(top: .circular(16)),
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          showZeroValue: false,
          labelAlignment: .bottom,
          textStyle: .new(
            fontSize: 56,
            fontWeight: .bold,
            color: Color(0xff3ddc85),
          ),
        ),
      ),
      if (handler is! LiveDataHandler)
        LineSeries(
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

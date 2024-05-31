import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/app/exercise/exercise_handler.dart';
import 'package:tendon_loader/app/graph/graph_handler.dart';
import 'package:tendon_loader/app/livedata/livedata_handler.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/widgets/raw_button.dart';

@immutable
class GraphWidget extends StatelessWidget {
  const GraphWidget({
    super.key,
    required this.title,
    required this.handler,
    required this.builder,
    required this.onExit,
  });

  final String title;
  final GraphHandler handler;
  final Widget Function() builder;
  final bool Function(String key) onExit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: PopScope(
          onPopInvoked: (value) async {
            final String key = await handler.exit();
            // TODO(mitul): Fix this
            if (key.isEmpty) Future.value(true);
            onExit(key);
          },
          child: Column(children: [
            _Header(handler: handler, builder: builder),
            const SizedBox(height: 16),
            _BarGraph(handler: handler),
            _ButtonBar(handler: handler),
          ]),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.handler, required this.builder});

  final GraphHandler handler;
  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChartData>(
      initialData: const ChartData(),
      stream: GraphHandler.stream,
      builder: (_, snapshot) {
        handler.graphData.insert(0, snapshot.data!);
        handler.graphCtrl?.updateDataSource(updatedDataIndex: 0);
        return Ink(
          color: handler.feedColor,
          child: Row(children: [Expanded(child: builder())]),
        );
      },
    );
  }
}

class _BarGraph extends StatelessWidget {
  const _BarGraph({required this.handler});

  final GraphHandler handler;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: handler.lineData != null
            ? const NumericAxis(minimum: 0, isVisible: false)
            : const CategoryAxis(minimum: 0, maximum: 0, isVisible: false),
        primaryYAxis: const NumericAxis(
          labelFormat: '{value} kg',
          axisLine: AxisLine(width: 0),
          // maximum: AppScope.of(context).settingsState.settings.graphScale,
          majorTickLines: MajorTickLines(size: 0),
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        series: <CartesianSeries<ChartData?, int>>[
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
            xValueMapper: (data, _) => 1,
            yValueMapper: (data, _) => data!.load,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            onRendererCreated: (ctrl) => handler.graphCtrl = ctrl,
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
      ),
    );
  }
}

class _ButtonBar extends StatelessWidget {
  const _ButtonBar({required this.handler});

  final GraphHandler handler;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RawButton.tile(
            leading: const Icon(Icons.play_arrow, color: Color(0xff3ddc85)),
            onTap: handler.start,
            child: const Text('Start'),
          ),
          if (handler is ExerciseHandler)
            RawButton.tile(
              leading: const Icon(Icons.pause, color: Color(0xFFDCC73D)),
              onTap: handler.pause,
              child: const Text('Pause'),
            ),
          RawButton.tile(
            leading: const Icon(Icons.stop, color: Color(0xffff534d)),
            onTap: handler.stop,
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }
}

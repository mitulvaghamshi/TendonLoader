import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/network/app_scope.dart';
import 'package:tendon_loader/network/chartdata.dart';
import 'package:tendon_loader/screens/exercise/models/exercise_handler.dart';
import 'package:tendon_loader/screens/graph/models/graph_handler.dart';
import 'package:tendon_loader/screens/livedata/models/livedata_handler.dart';

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
        child: WillPopScope(
          onWillPop: () async {
            final String key = await handler.exit();
            if (key.isEmpty) return true;
            return onExit(key);
          },
          child: Column(children: <Widget>[
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
          child: Row(children: <Widget>[Expanded(child: builder())]),
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
            ? NumericAxis(minimum: 0, isVisible: false)
            : CategoryAxis(minimum: 0, maximum: 0, isVisible: false),
        primaryYAxis: NumericAxis(
          labelFormat: '{value} kg',
          axisLine: const AxisLine(width: 0),
          maximum: AppScope.of(context).api.settings.graphScale,
          majorTickLines: const MajorTickLines(size: 0),
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              dataSource: handler.lineData!,
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
        children: <Widget>[
          RawButton.icon(
            left: const Icon(Icons.play_arrow, color: Color(0xff3ddc85)),
            right: const Text('Start'),
            onTap: handler.start,
          ),
          if (handler is ExerciseHandler)
            RawButton.icon(
              left: const Icon(Icons.pause, color: Color(0xFFDCC73D)),
              right: const Text('Pause'),
              onTap: handler.pause,
            ),
          RawButton.icon(
            left: const Icon(Icons.stop, color: Color(0xffff534d)),
            right: const Text('Stop'),
            onTap: handler.stop,
          ),
        ],
      ),
    );
  }
}

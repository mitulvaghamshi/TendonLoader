import 'package:api_server/api_server.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';
import 'package:tendon_loader/utils/utils.dart';

@immutable
class ExerciseDetail extends StatelessWidget {
  const ExerciseDetail(this.record, {super.key});

  final ExerciseRecord record;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      const SliverAppBar.medium(title: Text('Exercise Details')),
      SliverToBoxAdapter(
        child: _DataGraph(
          tagetLoad: record.targetLoad,
          items: record.chartData,
        ),
      ),
      SliverList.builder(
        itemCount: record.infoTable.length,
        itemBuilder: (_, index) =>
            _ListItem(item: record.infoTable.elementAt(index)),
      ),
    ],
  );
}

@immutable
class _ListItem extends StatelessWidget {
  const _ListItem({required this.item});

  final TableItem item;

  @override
  Widget build(BuildContext context) => ButtonFactory(
    child: Row(
      children: [
        Expanded(child: Text(item.label)),
        Expanded(child: Text(item.value)),
      ],
    ),
  );
}

@immutable
class _DataGraph extends StatelessWidget {
  const _DataGraph({required this.tagetLoad, required this.items});

  final double tagetLoad;
  final Iterable<ChartData> items;

  @override
  Widget build(BuildContext context) => SfCartesianChart(
    tooltipBehavior: TooltipBehavior(enable: true, header: 'Time/Load'),
    primaryXAxis: const NumericAxis(
      interval: 1,
      labelFormat: '{value} sec',
      edgeLabelPlacement: .shift,
    ),
    primaryYAxis: const NumericAxis(interval: 1, labelFormat: '{value} kg'),
    series: <LineSeries<ChartData, double>>[
      LineSeries(
        color: Colors.green,
        animationDuration: 7000,
        xValueMapper: (data, _) => data.time,
        yValueMapper: (data, _) => data.load,
        dataSource: items.toList(),
      ),
      LineSeries(
        color: Colors.orange,
        animationDuration: 0,
        xValueMapper: (data, _) => data.time,
        yValueMapper: (data, _) => data.load,
        dataSource: [
          .new(load: tagetLoad),
          .new(time: items.last.time, load: tagetLoad),
        ],
      ),
    ],
  );
}

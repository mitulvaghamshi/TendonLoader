import 'package:api_server/api_server.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';
import 'package:tendon_loader/utils/utils.dart';

@immutable
class const ExerciseDetail(final ExerciseRecord record, {super.key})
    extends StatelessWidget {
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
class const _ListItem({required final TableItem item}) extends StatelessWidget {
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
class const _DataGraph({
  required final double tagetLoad,
  required final Iterable<ChartData> items,
}) extends StatelessWidget {
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
      .new(
        color: Colors.green,
        animationDuration: 7000,
        xValueMapper: (data, _) => data.time,
        yValueMapper: (data, _) => data.load,
        dataSource: items.toList(),
      ),
      .new(
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

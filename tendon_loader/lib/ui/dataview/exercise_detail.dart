import 'package:flutter/material.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/ui/dataview/exercise_data_graph.dart';
import 'package:tendon_loader/ui/widgets/button_factory.dart';

typedef ExercisePayload =
    ({
      double targetLoad,
      Iterable<ChartData> chartData,
      Iterable<(String, String)> infoTable,
    });

@immutable
class ExerciseDetail extends StatelessWidget {
  const ExerciseDetail({super.key, required this.payload});

  final ExercisePayload payload;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar.medium(title: Text('Exercise Details')),
        SliverToBoxAdapter(
          child: ExerciseDataGraph(
            tagetLoad: payload.targetLoad,
            items: payload.chartData,
          ),
        ),
        SliverList.builder(
          itemCount: payload.infoTable.length,
          itemBuilder:
              (_, index) => _ListItem(row: payload.infoTable.elementAt(index)),
        ),
      ],
    );
  }
}

@immutable
class _ListItem extends StatelessWidget {
  const _ListItem({required this.row});

  final (String, String) row;

  @override
  Widget build(BuildContext context) {
    return ButtonFactory(
      child: Row(
        children: [
          Expanded(child: Text(row.$1)),
          Expanded(child: Text(row.$2)),
        ],
      ),
    );
  }
}

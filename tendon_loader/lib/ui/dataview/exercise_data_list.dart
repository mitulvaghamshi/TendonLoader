import 'package:flutter/material.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';

@immutable
class ExerciseDataList extends StatelessWidget {
  const ExerciseDataList({super.key, required this.items});

  final Iterable<ChartData> items;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      const SliverAppBar.medium(title: Text('Exercise Data')),
      const SliverToBoxAdapter(
        child: _ListItem(index: 'No', time: 'Load', load: 'Time'),
      ),
      SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final data = items.elementAt(index);
          return _ListItem(
            index: '${index + 1}',
            time: data.time.toStringAsFixed(2),
            load: data.load.toStringAsFixed(2),
          );
        },
      ),
    ]);
  }
}

@immutable
class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.index,
    required this.time,
    required this.load,
  });

  final String index;
  final String time;
  final String load;

  @override
  Widget build(BuildContext context) {
    return RawButton(
      child: Row(children: [
        Expanded(child: Text(index, textAlign: TextAlign.center)),
        Expanded(child: Text(time, textAlign: TextAlign.center)),
        Expanded(child: Text(load, textAlign: TextAlign.center)),
      ]),
    );
  }
}

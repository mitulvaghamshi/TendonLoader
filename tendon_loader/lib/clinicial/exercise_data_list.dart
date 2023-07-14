import 'package:flutter/material.dart';
import 'package:tendon_loader/widgets/raw_button.dart';
import 'package:tendon_loader/models/chartdata.dart';

@immutable
final class ExerciseDataList extends StatelessWidget {
  const ExerciseDataList({super.key, required this.items});

  final Iterable<ChartData> items;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverAppBar.large(title: const Text('Exercise Data List')),
      SliverList.builder(
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const _ListItem(first: 'No', second: 'Load', third: 'Time');
          }
          final data = items.elementAt(index - 1);
          return _ListItem(
            first: '${index + 1}',
            second: data.time.toStringAsFixed(2),
            third: data.load.toStringAsFixed(2),
          );
        },
      ),
    ]);
  }
}

@immutable
final class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.first,
    required this.second,
    required this.third,
  });

  final String first;
  final String second;
  final String third;

  @override
  Widget build(BuildContext context) {
    return RawButton(
      child: Row(children: [
        Expanded(child: Text(first, textAlign: TextAlign.center)),
        Expanded(child: Text(second, textAlign: TextAlign.center)),
        Expanded(child: Text(third, textAlign: TextAlign.center)),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class ExerciseDataList extends StatelessWidget {
  const ExerciseDataList({super.key, required this.items});

  final Iterable<ChartData> items;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      const SliverAppBar(title: Text('Exercise Data')),
      const SliverPersistentHeader(
        pinned: true,
        floating: true,
        delegate: _HeaderDelegate(),
      ),
      SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => _ListItem(
          index: index,
          data: items.elementAt(index),
        ),
      ),
    ]);
  }
}

@immutable
class _ListItem extends StatelessWidget {
  const _ListItem({required this.index, required this.data});

  final int index;
  final ChartData data;

  @override
  Widget build(BuildContext context) {
    return RawButton(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text('${index + 1}'),
        Text(data.time.toStringAsFixed(2)),
        Text(data.load.toStringAsFixed(2)),
      ]),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  const _HeaderDelegate();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const RawButton(
      color: Colors.blueGrey,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text('No.', style: Styles.whiteBold),
        Text('Time', style: Styles.whiteBold),
        Text('Load', style: Styles.whiteBold),
      ]),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

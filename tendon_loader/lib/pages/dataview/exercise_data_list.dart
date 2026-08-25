import 'package:api_server/api_server.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class const ExerciseDataList(final Iterable<ChartData> items, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      const SliverAppBar(title: Text('Exercise Data')),
      const SliverPersistentHeader(
        pinned: true,
        floating: true,
        delegate: _HeaderDelegate(),
      ),
      SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, index) =>
            _ListItem(index: index, data: items.elementAt(index)),
      ),
    ],
  );
}

@immutable
class const _ListItem({required final int index, required final ChartData data})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ButtonFactory(
    child: Row(
      mainAxisAlignment: .spaceAround,
      children: [
        Text('${index + 1}'),
        Text(data.time.toStringAsFixed(2)),
        Text(data.load.toStringAsFixed(2)),
      ],
    ),
  );
}

@immutable
class const _HeaderDelegate() extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => const ButtonFactory(
    color: Colors.blueGrey,
    child: Row(
      mainAxisAlignment: .spaceAround,
      children: [
        Text('No.', style: Styles.whiteBold),
        Text('Time', style: Styles.whiteBold),
        Text('Load', style: Styles.whiteBold),
      ],
    ),
  );

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(_HeaderDelegate oldDelegate) => false;
}

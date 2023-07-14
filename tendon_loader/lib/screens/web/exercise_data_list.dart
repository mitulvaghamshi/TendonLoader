import 'package:flutter/cupertino.dart';
import 'package:tendon_loader/common/widgets/no_result_widget.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/models/exercise.dart';

@immutable
final class ExerciseDataList extends StatelessWidget {
  const ExerciseDataList({super.key});

  @override
  Widget build(BuildContext context) {
    const export = Exercise.empty();
    //  AppScope.of(context).userState.excercise;
    final list = export.data.toList();
    if (list.isEmpty) return const NoResultWidget();
    return CustomScrollView(
      semanticChildCount: list.length,
      slivers: [
        const CupertinoSliverNavigationBar(
          heroTag: 'data-list-nav',
          automaticallyImplyLeading: false,
          largeTitle: Row(children: [
            Expanded(child: Text('NO.', textAlign: TextAlign.center)),
            Expanded(child: Text('LOAD', textAlign: TextAlign.center)),
            Expanded(child: Text('TIME', textAlign: TextAlign.center)),
          ]),
        ),
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.all(8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((_, index) {
              if (index < list.length) {
                return Row(children: [
                  _buildItem('${index + 1}'),
                  _buildItem(list[index].time.toStringAsFixed(2)),
                  _buildItem(list[index].load.toStringAsFixed(2)),
                ]);
              }
              return null;
            }),
          ),
        ),
      ],
    );
  }
}

extension on ExerciseDataList {
  Expanded _buildItem(String text) => Expanded(
      child: RawButton(child: Text(text, textAlign: TextAlign.center)));
}

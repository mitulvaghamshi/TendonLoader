import 'package:flutter/cupertino.dart';
import 'package:tendon_loader/common/widgets/no_result_widget.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/network/app_scope.dart';

@immutable
class DataList extends StatelessWidget {
  const DataList({super.key});

  @override
  Widget build(BuildContext context) {
    final export = AppScope.of(context).api.excercise;
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

extension on DataList {
  Expanded _buildItem(String text) => Expanded(
      child: RawButton(child: Text(text, textAlign: TextAlign.center)));
}

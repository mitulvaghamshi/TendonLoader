import 'package:flutter/cupertino.dart';
import 'package:tendon_loader/common/models/chartdata.dart';
import 'package:tendon_loader/common/models/export.dart';
import 'package:tendon_loader/common/widgets/custom_widget.dart';
import 'package:tendon_loader/common/widgets/no_result_widget.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';

@immutable
class DataList extends StatelessWidget {
  const DataList({super.key});

  @override
  Widget build(BuildContext context) {
    final Export export = AppState.of(context).getSelectedExport();
    final List<ChartData>? list = export.exportData?.toList();
    if (list == null || list.isEmpty) return const NoResultWidget();
    return CustomScrollView(
      semanticChildCount: list.length,
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          heroTag: 'data-list-nav',
          automaticallyImplyLeading: false,
          largeTitle: Row(children: const <Widget>[
            Expanded(child: Text('NO.', textAlign: TextAlign.center)),
            Expanded(child: Text('LOAD', textAlign: TextAlign.center)),
            Expanded(child: Text('TIME', textAlign: TextAlign.center)),
          ]),
        ),
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.all(8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((_, int index) {
              if (index < list.length) {
                return Row(children: <Widget>[
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
  Expanded _buildItem(String text) {
    return Expanded(
      child: CustomWidget(
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}

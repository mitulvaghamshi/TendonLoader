import 'package:flutter/cupertino.dart';
import 'package:tendon_loader/common/router/router.dart';
import 'package:tendon_loader/network/exercise.dart';
import 'package:tendon_loader/screens/web/utils/popup_action.dart';
import 'package:tendon_loader/screens/web/widgets/dismissable_tile.dart';
import 'package:tendon_loader/screens/web/widgets/search_field.dart';

class ExportList extends StatefulWidget {
  const ExportList({
    super.key,
    /* required this.userId, required this.searchList */
  });

  // final int userId;

  @override
  State<ExportList> createState() => _ExportListState();
}

class _ExportListState extends State<ExportList> {
  final TextEditingController _searchCtrl = TextEditingController();
  Iterable<Exercise> searchList = [];

  void _update(VoidCallback action) => setState(action);

  @override
  void dispose() {
    super.dispose();
    _searchCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        semanticChildCount: searchList.length,
        slivers: <Widget>[
          const CupertinoSliverNavigationBar(
            heroTag: 'export-list-nav',
            largeTitle: Text('widget.userId'),
          ),
          SliverSafeArea(
            top: false,
            minimum: const EdgeInsets.all(8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((_, index) {
                if (index == 0) {
                  return SearchField(
                      onSearch: _search, controller: _searchCtrl);
                } else if (index < searchList.length) {
                  final Exercise export = searchList.elementAt(index);
                  return DismissableTile(
                    itemKey: export.userId.toString(),
                    barColor: export.mvcValue != null
                        ? const Color(0xffff534d)
                        : const Color(0xff3ddc85),
                    title: Text(export.datetime.toString()),
                    subTitle: const Text('export.title'),
                    trailing: CupertinoButton(
                      child: const Icon(CupertinoIcons.info),
                      onPressed: () =>
                          _handler(PopupAction.itemSessionInfo, export),
                    ),
                    handler: (action) => _handler(action, export),
                  );
                }
                return null;
              }),
            ),
          ),
        ],
      ),
    );
  }
}

extension on _ExportListState {
  void _search() {
    final String query = _searchCtrl.text.toLowerCase();
    Iterable<Exercise> filterList = searchList;
    if (query.isNotEmpty) {
      filterList = searchList.where((e) {
        return 'e.fileName.toLowerCase()'.contains(query);
      });
    }
    _update(() => searchList = filterList);
  }

  Future<void> _handler(PopupAction action, Exercise export) async {
    switch (action) {
      case PopupAction.itemTap:
        // AppScope.of(context).api.excercise = export;
        const ExportViewRoute().go(context);
      case PopupAction.itemDelete:
      // await export.reference!.delete();
      case PopupAction.itemDownload:
        await export.download();
      case PopupAction.itemSessionInfo:
        // AppScope.of(context).selectedExport = export;
        const SessionInfoRoute().go(context);
      default:
    }
  }
}

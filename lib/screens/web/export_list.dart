import 'package:flutter/cupertino.dart';
import 'package:tendon_loader/common/models/export.dart';
import 'package:tendon_loader/common/router/router.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';
import 'package:tendon_loader/screens/web/utils/popup_action.dart';
import 'package:tendon_loader/screens/web/widgets/dismissable_tile.dart';
import 'package:tendon_loader/screens/web/widgets/search_field.dart';

class ExportList extends StatefulWidget {
  const ExportList({super.key, required this.title, required this.searchList});

  final String title;
  final Iterable<Export> searchList;

  @override
  State<ExportList> createState() => _ExportListState();
}

class _ExportListState extends State<ExportList> {
  final TextEditingController _searchCtrl = TextEditingController();
  late Iterable<Export> searchList = widget.searchList;

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
          CupertinoSliverNavigationBar(
            heroTag: 'export-list-nav',
            largeTitle: Text(widget.title),
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
                  final Export export = searchList.elementAt(index);
                  return DismissableTile(
                    itemKey: export.userId!,
                    barColor: export.isMVC
                        ? const Color(0xffff534d)
                        : const Color(0xff3ddc85),
                    title: Text(export.dateTime),
                    subTitle: Text(export.title),
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
    Iterable<Export> filterList = widget.searchList;
    if (query.isNotEmpty) {
      filterList = widget.searchList.where((e) {
        return e.fileName.toLowerCase().contains(query);
      });
    }
    _update(() => searchList = filterList);
  }

  Future<void> _handler(PopupAction action, Export export) async {
    switch (action) {
      case PopupAction.itemTap:
        AppState.of(context).selectedExport = export;
        const ExportViewRoute().go(context);
        break;
      case PopupAction.itemDelete:
        await export.reference!.delete();
        break;
      case PopupAction.itemDownload:
        await export.download();
        break;
      case PopupAction.itemSessionInfo:
        AppState.of(context).selectedExport = export;
        const SessionInfoRoute().go(context);
        break;
      default:
        break;
    }
  }
}

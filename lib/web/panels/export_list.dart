import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/web/app_state/app_state_scope.dart';
import 'package:tendon_loader/web/app_state/app_state_widget.dart';
import 'package:tendon_loader/custom/app_frame.dart';
import 'package:tendon_loader/custom/search_text_field.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/web/common.dart';
import 'package:tendon_loader/web/tiles/export_tile.dart';

class ExportList extends StatefulWidget {
  const ExportList({Key? key}) : super(key: key);

  @override
  _ExportListState createState() => _ExportListState();
}

class _ExportListState extends State<ExportList> {
  final TextEditingController _searchCtrl = TextEditingController();
  late Iterable<Export>? _exportList = AppStateScope.of(context).exportList;

  void _onSearch() {
    final Iterable<Export>? _filterExports =
        AppStateWidget.of(context).filterExports(_searchCtrl.text);
    setState(() => _exportList = _filterExports);
  }

  @override
  void dispose() {
    super.dispose();
    _searchCtrl.dispose();
    userNotifier.removeListener(_onSearch);
  }

  @override
  void initState() {
    super.initState();
    userNotifier.addListener(_onSearch);
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: SizedBox(
        width: 350,
        child: Column(children: <Widget>[
          SearchTextField(
            onSearch: _onSearch,
            controller: _searchCtrl,
            hint: 'Search exports...',
          ),
          Expanded(
            child: _exportList == null
                ? const SizedBox()
                : ListView.builder(
                    itemCount: _exportList!.length,
                    itemBuilder: (_, int index) => ExportTile(
                      export: _exportList!.elementAt(index),
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/web/tiles/export_tile.dart';

class ExportList extends StatefulWidget {
  const ExportList({Key? key}) : super(key: key);

  @override
  _ExportListState createState() => _ExportListState();
}

class _ExportListState extends State<ExportList> {
  final TextEditingController _searchCtrl = TextEditingController();

  void _onSearch([String? value]) {
    final Iterable<int> _filter = AppStateWidget.of(context).filter(
      filter: _searchCtrl.text,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: 350,
        child: Column(children: <Widget>[
          TextField(
            onSubmitted: _onSearch,
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'Search export',
              prefixIcon: IconButton(
                onPressed: _onSearch,
                icon: const Icon(Icons.search),
              ),
              suffixIcon: IconButton(
                onPressed: _searchCtrl.clear,
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<int?>(
              valueListenable: userClick,
              builder: (_, int? value, Widget? child) {
                if (value == null) return const SizedBox();
                final List<Export>? _exports =
                    AppStateWidget.of(context).getUser(value).exports;
                return ListView.builder(
                  itemCount: _exports!.length,
                  itemBuilder: (_, int index) => ExportTile(
                    export: _exports[index],
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

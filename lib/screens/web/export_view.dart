import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/common/models/export.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';
import 'package:tendon_loader/screens/web/data_graph.dart';
import 'package:tendon_loader/screens/web/data_list.dart';

class ExportView extends StatefulWidget {
  const ExportView({super.key});

  @override
  State<ExportView> createState() => _ExportViewState();
}

class _ExportViewState extends State<ExportView> {
  late final Export export = AppState.of(context).getSelectedExport();
  bool _showList = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        if (constraints.biggest.width > 600) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(export.fileName),
            ),
            child: Row(children: const <Widget>[
              SizedBox(width: 300, child: DataList()),
              VerticalDivider(width: 2, thickness: 2),
              Expanded(child: DataGraph()),
            ]),
          );
        }
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(export.dateTime),
            trailing: CupertinoButton(
              onPressed: () => setState(() => _showList = !_showList),
              child: Icon(_showList ? Icons.show_chart : Icons.list),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _showList ? const DataList() : const DataGraph(),
          ),
        );
      },
    );
  }
}

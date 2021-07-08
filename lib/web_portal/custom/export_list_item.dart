import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/item_action.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/web_portal/handler/click_handler.dart';

class ExportListItem extends StatelessWidget {
  const ExportListItem({Key? key, required this.export}) : super(key: key);

  final Export export;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey<String>(export.reference!.id),
      horizontalTitleGap: 5,
      contentPadding: const EdgeInsets.all(5),
      title: Text(export.dateTime, style: const TextStyle(fontSize: 16)),
      subtitle: export.isComplate
          ? const Text('Complate', style: TextStyle(color: colorGoogleGreen))
          : const Text('Incomplate', style: TextStyle(color: colorRed400)),
      leading: export.isMVC
          ? const CustomButton(color: colorOrange400, child: Text('MVC'))
          : const CustomButton(color: colorGoogleGreen, child: Text('EXE')),
      onTap: () {
        if (export.exportData.isNotEmpty) exportItemSink.add(export);
      },
      trailing: PopupMenuButton<ItemAction>(
        icon: const Icon(Icons.more_vert_rounded),
        itemBuilder: (_) => <PopupMenuItem<ItemAction>>[
          const PopupMenuItem<ItemAction>(
            value: ItemAction.download,
            child: ListTile(
              title: Text('Download'),
              leading: Icon(Icons.download_rounded),
            ),
          ),
          const PopupMenuItem<ItemAction>(
            value: ItemAction.delete,
            child: ListTile(
              title: Text('Delete', style: TextStyle(color: colorRed400)),
              leading: Icon(Icons.delete_rounded, color: colorRed400),
            ),
          ),
        ],
        onSelected: (ItemAction action) async {
          if (action == ItemAction.download) {
            await Future<void>.microtask(export.download);
          } else if (action == ItemAction.delete) {
            await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  actionsPadding: const EdgeInsets.only(bottom: 10, left: 50, right: 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const <Widget>[
                    Icon(Icons.warning_rounded, size: 50),
                    Text('Do you really want to delete?'),
                  ]),
                  actions: <Widget>[
                    CustomButton(
                      icon: const Icon(Icons.delete_rounded, color: colorRed400),
                      onPressed: () async {
                        Navigator.pop(context);
                        context.model.removeExportBy(export.reference!);
                        context.view.refresh();
                        await Future<void>.microtask(export.deleteExport);
                      },
                      child: const Text('Yes, Delete!', style: TextStyle(color: colorRed400)),
                    ),
                    CustomButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: Navigator.of(context).pop,
                      child: const Text('Cencel'),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

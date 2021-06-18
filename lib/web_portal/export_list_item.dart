import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/custom/custom_avater.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/constants/item_action.dart';
import 'package:tendon_loader/handler/click_handler.dart'; 

class ExportListItem extends StatelessWidget {
  const ExportListItem({Key? key, required this.export}) : super(key: key);

  final Export export;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey<String>(export.reference!.id),
      contentPadding: const EdgeInsets.all(5),
      title: Text(export.title, style: const TextStyle(fontSize: 16)),
      subtitle: export.isComplate
          ? const Text('Complate', style: TextStyle(color: Colors.green))
          : const Text('Incomplate', style: TextStyle(color: Colors.red)),
      leading: export.isMVC
          ? const CustomAvatar('MVC', bgColor: Colors.orange)
          : const CustomAvatar('EXE', bgColor: Colors.green),
      onTap: () {
        if (export.exportData.isNotEmpty) exportItemSink.add(export);
      },
      trailing: PopupMenuButton<ItemAction>(
        icon: const Icon(Icons.more_vert_rounded),
        onSelected: (ItemAction action) => _onSelected(context, action),
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
              title: Text('Delete', style: TextStyle(color: Colors.red)),
              leading: Icon(Icons.delete_rounded, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSelected(BuildContext context, ItemAction action) async {
    if (action == ItemAction.download) {
      await export.download();
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
                color: Colors.red,
                text: 'Yes, Delete!',
                icon: Icons.delete_rounded,
                onPressed: () async {
                  Navigator.pop(context);
                  await export.delete();
                  AppStateScope.of(context).remove(export.reference!);
                  AppStateWidget.of(context).refresh();
                },
              ),
              CustomButton(
                text: 'Cencel',
                icon: Icons.cancel,
                onPressed: Navigator.of(context).pop,
                color: const Color.fromRGBO(61, 220, 132, 1),
              ),
            ],
          );
        },
      );
    }
  }
}

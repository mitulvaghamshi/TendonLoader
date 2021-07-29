import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/utils/themes.dart';

class ExportTile extends StatelessWidget {
  const ExportTile({Key? key, required this.export, required this.onDelete}) : super(key: key);

  final Export export;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 24,
      key: ValueKey<String>(export.reference!.id),
      onTap: () => Future<void>.microtask(() => clickNotifier.value = export),
      leading: CustomButton(rounded: true, left: Text(export.isMVC ? 'MVC' : 'EXE', style: ts18BFF)),
      title: Text(export.dateTime, style: TextStyle(color: export.isComplate! ? colorAGreen400 : colorRed400)),
      trailing: PopupMenuButton<PopupAction>(
        icon: const Icon(Icons.more_vert_rounded),
        itemBuilder: (_) => <PopupMenuItem<PopupAction>>[
          const PopupMenuItem<PopupAction>(
            value: PopupAction.download,
            child: ListTile(title: Text('Download'), leading: Icon(Icons.download_rounded)),
          ),
          const PopupMenuItem<PopupAction>(
            value: PopupAction.delete,
            child: ListTile(
              title: Text('Delete', style: TextStyle(color: colorRed400)),
              leading: Icon(Icons.delete_rounded, color: colorRed400),
            ),
          ),
        ],
        onSelected: (PopupAction action) async {
          if (action == PopupAction.download) {
            await Future<void>.microtask(export.download);
          } else if (action == PopupAction.delete) {
            await confirmDelete(context, onDelete);
          }
        },
      ),
    );
  }
}

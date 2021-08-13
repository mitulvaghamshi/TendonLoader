import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/webportal/homepage.dart';

class ExportTile extends StatelessWidget {
  const ExportTile({Key? key, required this.export, required this.onDelete}) : super(key: key);

  final Export export;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(export.dateTime),
      contentPadding: const EdgeInsets.all(5),
      key: ValueKey<String>(export.reference!.id),
      onTap: () => Future<void>.microtask(() => clickNotifier.value = export),
      leading: CustomButton(rounded: true, left: Text(export.isMVC ? 'MVC' : 'EXE')),
      subtitle: Text(
        export.isComplate! ? 'Complete' : 'Incomplete',
        style: TextStyle(color: export.isComplate! ? colorGoogleGreen : colorRed400),
      ),
      trailing: PopupMenuButton<PopupAction>(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (_) => <PopupMenuItem<PopupAction>>[
          const PopupMenuItem<PopupAction>(
            value: PopupAction.download,
            child: ListTile(
              title: Text('Download'),
              leading: Icon(Icons.file_download),
              subtitle: Text('Save as Excel (zip).'),
            ),
          ),
          const PopupMenuItem<PopupAction>(
            value: PopupAction.delete,
            child: ListTile(
              subtitle: Text('Cannot be restored!'),
              leading: Icon(Icons.delete_forever, color: colorRed400),
              title: Text('Delete', style: TextStyle(color: colorRed400)),
            ),
          ),
        ],
        onSelected: (PopupAction action) async {
          if (action == PopupAction.download) {
            await Future<void>.microtask(export.download);
          } else if (action == PopupAction.delete) {
            onDelete();
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/web/lists/user_list.dart';

class ExportTile extends StatelessWidget {
  const ExportTile({Key? key, required this.export}) : super(key: key);

  final Export export;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(export.dateTime),
      contentPadding: const EdgeInsets.all(5),
      key: ValueKey<String>(export.reference!.id),
      onTap: () => Future<void>.microtask(() {
        exportClick.value = export;
      }),
      leading: CustomButton(
        rounded: true,
        padding: EdgeInsets.zero,
        left: Text(export.isMVC ? 'MVC' : 'EXE'),
      ),
      subtitle: Text(
        export.isComplate! ? 'Complete' : 'Incomplete',
        style: TextStyle(
          color: export.isComplate! ? colorGoogleGreen : colorRed400,
        ),
      ),
      trailing: PopupMenuButton<PopupAction>(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (_) => <PopupMenuItem<PopupAction>>[
          const PopupMenuItem<PopupAction>(
            value: PopupAction.download,
            child: ListTile(
              title: Text('Download'),
              leading: Icon(Icons.file_download),
            ),
          ),
          const PopupMenuItem<PopupAction>(
            value: PopupAction.delete,
            child: ListTile(
              leading: Icon(Icons.delete_forever, color: colorRed400),
              title: Text('Delete', style: TextStyle(color: colorRed400)),
            ),
          ),
        ],
        onSelected: (PopupAction action) async {
          if (action == PopupAction.download) {
            await Future<void>.microtask(export.download);
          } else if (action == PopupAction.delete) {
            await CustomDialog.show<void>(
              context,
              content: Scaffold(
                appBar: AppBar(
                  title: const Text('Delete this export?'),
                ),
                body: Center(
                  child: CustomButton(
                    radius: 8,
                    color: colorRed900,
                    left: const Icon(
                      Icons.delete,
                      color: colorWhite,
                    ),
                    right: const Text(
                      'Permanently delete',
                      style: TextStyle(color: colorWhite),
                    ),
                    onPressed: () {
                      context.pop();
                      userClick.value = null;
                      export.reference!.delete();
                      UserList.of(context).refresh();
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

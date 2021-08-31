import 'package:flutter/material.dart';
import 'package:tendon_loader/web/app_state/app_state_widget.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/web/common.dart';
import 'package:tendon_loader/web/dialogs/session_info.dart';

class ExportTile extends StatelessWidget {
  const ExportTile({Key? key, required this.export}) : super(key: key);

  final Export export;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 5,
      selected: export == exportNotifier.value,
      title: Text(export.dateTime),
      contentPadding: const EdgeInsets.all(5),
      key: ValueKey<String>(export.reference!.id),
      onTap: () => exportNotifier.value = export,
      leading: CustomButton(
        rounded: true,
        padding: EdgeInsets.zero,
        left: Text(export.isMVC ? 'MVC' : 'EXE'),
      ),
      subtitle: Text(
        export.status,
        style: TextStyle(
          color: export.isComplate! ? colorMidGreen : colorErrorRed,
        ),
      ),
      trailing: PopupMenuButton<PopupAction>(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (_) => <PopupMenuItem<PopupAction>>[
          const PopupMenuItem<PopupAction>(
            value: PopupAction.sesssionInfo,
            child: ListTile(
              title: Text('Session info'),
              leading: Icon(Icons.info),
            ),
          ),
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
              leading: Icon(Icons.delete_forever, color: colorErrorRed),
              title: Text('Delete', style: TextStyle(color: colorErrorRed)),
            ),
          ),
        ],
        onSelected: (PopupAction action) async {
          switch (action) {
            case PopupAction.download:
              await Future<void>.microtask(export.download);
              break;
            case PopupAction.sesssionInfo:
              await CustomDialog.show<void>(
                context,
                title: 'Session info',
                size: const Size(370, 700),
                content: SessionInfo(export: export),
              );
              break;
            case PopupAction.delete:
              await confirmDelete(
                context,
                title: 'Delete this export?',
                action: () async => AppStateWidget.of(context)
                    .removeExport(export)
                    .then(context.pop),
              );
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

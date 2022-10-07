import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/models/export.dart';
import 'package:tendon_loader/shared/utils/extension.dart';
import 'package:tendon_loader/shared/widgets/alert_widget.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';
import 'package:tendon_loader/web/common.dart';
import 'package:tendon_loader/web/states/app_state_widget.dart';
import 'package:tendon_loader/web/widgets/session_info.dart';

class ExportTile extends StatelessWidget {
  const ExportTile({super.key, required this.export});

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
      leading: ButtonWidget(left: Text(export.isMVC ? 'MVC' : 'EXE')),
      subtitle: Text(
        export.status,
        style: TextStyle(
          color: export.isComplate!
              ? const Color(0xff3ddc85)
              : const Color(0xffff534d),
        ),
      ),
      trailing: _MenuButton(export: export),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.export});

  final Export export;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopupAction>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) => <PopupMenuItem<PopupAction>>[
        const PopupMenuItem<PopupAction>(
          value: PopupAction.sessionInfo,
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
            leading: Icon(Icons.delete_forever, color: Color(0xffff534d)),
            title: Text('Delete', style: TextStyle(color: Color(0xffff534d))),
          ),
        ),
      ],
      onSelected: (PopupAction action) async {
        switch (action) {
          case PopupAction.download:
            await Future<void>.microtask(export.download);
            break;
          case PopupAction.sessionInfo:
            await AlertWidget.show<void>(
              context,
              title: 'Session info',
              size: const Size(370, 600),
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
    );
  }
}

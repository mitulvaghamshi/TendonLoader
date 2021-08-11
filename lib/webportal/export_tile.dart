import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/webportal/homepage.dart';
import 'package:tendon_loader/webportal/popup_menu.dart';
import 'package:tendon_loader/utils/themes.dart';

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
      trailing: PopupMenu(onSelected: (PopupAction action) async {
        if (action == PopupAction.download) {
          await Future<void>.microtask(export.download);
        } else if (action == PopupAction.delete) {
          await confirmDelete(context, onDelete);
        }
      }),
    );
  }
}

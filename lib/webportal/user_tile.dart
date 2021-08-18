import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/webportal/exercise_history.dart';
import 'package:tendon_loader/webportal/homepage.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    Key? key,
    required this.id,
    required this.onDelete,
    this.filter,
  }) : super(key: key);

  final int id;
  final String? filter;
  final Future<void> Function(VoidCallback) onDelete;

  Future<void> _exerciseHistory(BuildContext context) async {
    return CustomDialog.show<void>(
      context,
      title: 'Exercise History',
      content: ExerciseHistory(id: id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Patient _user = context.view.getUserBy(id);
    return ExpansionTile(
      maintainState: true,
      key: ValueKey<int>(id),
      subtitle: Text(_user.childCount),
      tilePadding: const EdgeInsets.all(5),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      title: Text(_user.id, style: ts18B, maxLines: 1),
      leading: CustomButton(
        rounded: true,
        left: Text(_user.avatar, style: ts18B),
      ),
      trailing: PopupMenuButton<PopupAction>(
        icon: const Icon(Icons.settings),
        itemBuilder: (_) => <PopupMenuItem<PopupAction>>[
          PopupMenuItem<PopupAction>(
            value: PopupAction.isClinician,
            child: StatefulBuilder(
              builder: (_, void Function(void Function()) setState) {
                return CheckboxListTile(
                  activeColor: colorBlue,
                  value: _user.prescription!.isAdmin,
                  title: const Text('Set as Clinician?'),
                  controlAffinity: ListTileControlAffinity.leading,
                  subtitle: const Text('Can access web portal.'),
                  onChanged: (bool? value) async {
                    setState(() => _user.prescription!.isAdmin = value);
                    await Future<void>.microtask(() async {
                      await _user.prescriptionRef!.update(<String, bool>{
                        keyIsAdmin: _user.prescription!.isAdmin!
                      });
                    });
                  },
                );
              },
            ),
          ),
          const PopupMenuItem<PopupAction>(
            value: PopupAction.history,
            child: ListTile(
              title: Text('Exercise History'),
              leading: Icon(Icons.history),
            ),
          ),
          const PopupMenuItem<PopupAction>(
            value: PopupAction.prescribe,
            child: ListTile(
              title: Text('Edit Prescriptions'),
              leading: Icon(Icons.edit),
            ),
          ),
          const PopupMenuItem<PopupAction>(
            value: PopupAction.download,
            child: ListTile(
              title: Text('Download All'),
              leading: Icon(Icons.file_download),
              subtitle: Text('Save all exports (zip).'),
            ),
          ),
          const PopupMenuItem<PopupAction>(
            value: PopupAction.delete,
            child: ListTile(
              subtitle: Text('Cannot be restored!'),
              leading: Icon(Icons.delete_forever, color: colorRed400),
              title: Text(
                'Delete All',
                style: TextStyle(color: colorRed400),
              ),
            ),
          ),
        ],
        onSelected: (PopupAction action) async {
          if (action == PopupAction.isClinician) {
            // Action Handled by popup item itself.
          } else if (action == PopupAction.history) {
            await _exerciseHistory(context);
          } else if (action == PopupAction.prescribe) {
            await _user.prescribe(context);
          } else if (action == PopupAction.download) {
            await Future<void>.microtask(_user.download);
          } else if (action == PopupAction.delete) {
            await onDelete(_user.deleteAll);
          }
        },
      ),
      children: ListTile.divideTiles(
        context: context,
        tiles: _user.exportTiles(filter: filter, onDelete: onDelete),
      ).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/web/dialogs/exercise_history.dart';

class UserTile extends StatelessWidget {
  const UserTile({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final Patient _user = AppStateWidget.of(context).getUser(id);
    return ListTile(
      horizontalTitleGap: 5,
      selected: id == userClick.value,
      key: ValueKey<Patient>(_user),
      subtitle: Text(_user.exportCount),
      onTap: () {
        exportClick.value = null;
        userClick.value = id;
      },
      contentPadding: const EdgeInsets.all(5),
      title: Text(_user.id, style: ts18w5, maxLines: 1),
      leading: CustomButton(
        rounded: true,
        padding: EdgeInsets.zero,
        left: Text(_user.avatar, style: ts18w5),
      ),
      trailing: PopupMenuButton<PopupAction>(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (_) => <PopupMenuItem<PopupAction>>[
          PopupMenuItem<PopupAction>(
            value: PopupAction.isClinician,
            child: StatefulBuilder(
              builder: (_, void Function(void Function()) setState) {
                return CheckboxListTile(
                  activeColor: colorIconBlue,
                  value: _user.prescription!.isAdmin,
                  title: const Text('Allow web access?'),
                  controlAffinity: ListTileControlAffinity.leading,
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
            ),
          ),
          const PopupMenuItem<PopupAction>(
            value: PopupAction.delete,
            child: ListTile(
              leading: Icon(Icons.delete_forever, color: colorErrorRed),
              title: Text('Delete All', style: TextStyle(color: colorErrorRed)),
            ),
          ),
        ],
        onSelected: (PopupAction action) async {
          switch (action) {
            case PopupAction.download:
              await Future<void>.microtask(_user.download);
              break;
            case PopupAction.history:
              await CustomDialog.show<void>(
                context,
                title: _user.id,
                content: ExerciseHistory(user: _user),
              );
              break;
            case PopupAction.prescribe:
              await CustomDialog.show<void>(
                context,
                title: _user.id,
                content: NewExercise(user: _user),
              );
              break;
            case PopupAction.delete:
              await confirmDelete(
                context,
                title: 'Delete all export?\nfor: ${_user.id}',
                action: () async {
                  exportClick.value = null;
                  userClick.value = null;
                  await _user.deleteAll();
                  context.pop();
                },
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

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
import 'package:tendon_loader/web/lists/user_list.dart';

class UserTile extends StatelessWidget {
  const UserTile({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final Patient _user = AppStateWidget.of(context).getUser(id);
    return ListTile(
      key: ValueKey<int>(id),
      subtitle: Text(_user.exportCount),
      onTap: () => userClick.value = id,
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
                  activeColor: colorBlue,
                  value: _user.prescription!.isAdmin,
                  title: const Text('Allow web portal access?'),
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
              leading: Icon(Icons.delete_forever, color: colorRed400),
              title: Text('Delete All', style: TextStyle(color: colorRed400)),
            ),
          ),
        ],
        onSelected: (PopupAction action) async {
          switch (action) {
            case PopupAction.history:
              await CustomDialog.show<void>(
                context,
                content: ExerciseHistory(patient: _user),
              );
              break;
            case PopupAction.prescribe:
              await CustomDialog.show<void>(
                context,
                content: NewExercise(user: _user),
              );
              break;
            case PopupAction.download:
              await Future<void>.microtask(_user.download);
              break;
            case PopupAction.delete:
              await CustomDialog.show<void>(
                context,
                content: Scaffold(
                  appBar: AppBar(
                    title: const Text('Delete all exports?'),
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
                        _user.deleteAll();
                        UserList.of(context).refresh();
                      },
                    ),
                  ),
                ),
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

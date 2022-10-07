import 'package:flutter/material.dart';
import 'package:tendon_loader/app/exercise/new_exercise.dart';
import 'package:tendon_loader/shared/models/patient.dart';
import 'package:tendon_loader/shared/utils/constants.dart';
import 'package:tendon_loader/shared/utils/extension.dart';
import 'package:tendon_loader/shared/widgets/alert_widget.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';
import 'package:tendon_loader/web/common.dart';
import 'package:tendon_loader/web/states/app_state_widget.dart';
import 'package:tendon_loader/web/widgets/exercise_history.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final Patient kUser = AppStateWidget.of(context).getUser(id);
    return ListTile(
      horizontalTitleGap: 5,
      key: ValueKey<Patient>(kUser),
      subtitle: Text(kUser.exportCount),
      contentPadding: const EdgeInsets.all(5),
      title: Text(
        kUser.id,
        maxLines: 1,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      trailing: _MenuButton(user: kUser, id: id),
      leading: ButtonWidget(
        left: Text(
          kUser.avatar,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      onTap: () {
        exportNotifier.value = null;
        userNotifier.value = id;
      },
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.user, required this.id});

  final Patient user;
  final int id;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopupAction>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) => <PopupMenuItem<PopupAction>>[
        PopupMenuItem<PopupAction>(
          value: PopupAction.isClinician,
          child: StatefulBuilder(
            builder: (_, void Function(void Function()) setState) {
              return CheckboxListTile(
                value: user.prescription!.isAdmin,
                title: const Text('Allow web access?'),
                activeColor: const Color(0xFF007AFF),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) async {
                  setState(() => user.prescription!.isAdmin = value);
                  await Future<void>.microtask(() async {
                    await user.prescriptionRef!.update(<String, bool>{
                      keyIsAdmin: user.prescription!.isAdmin!
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
            leading: Icon(Icons.delete_forever, color: Color(0xffff534d)),
            title:
                Text('Delete All', style: TextStyle(color: Color(0xffff534d))),
          ),
        ),
      ],
      onSelected: (PopupAction action) async {
        switch (action) {
          case PopupAction.download:
            await Future<void>.microtask(user.download);
            break;
          case PopupAction.history:
            await AlertWidget.show<void>(
              context,
              title: user.id,
              size: const Size(300, 500),
              content: ExerciseHistory(user: user),
            );
            break;
          case PopupAction.prescribe:
            await AlertWidget.show<void>(
              context,
              title: user.id,
              size: const Size(350, 550),
              content: NewExercise(user: user),
            );
            break;
          case PopupAction.delete:
            await confirmDelete(
              context,
              title: 'Delete all export?',
              action: () async => AppStateWidget.of(context)
                  .removeAllExports(id)
                  .then<void>(context.pop),
            );
            break;
          default:
            break;
        }
      },
    );
  }
}

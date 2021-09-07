/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/themes.dart';

final ValueNotifier<int?> userNotifier = ValueNotifier<int?>(null);

final ValueNotifier<Export?> exportNotifier = ValueNotifier<Export?>(null);

enum PopupAction {
  isClinician,
  download,
  delete,
  prescribe,
  history,
  sesssionInfo,
}

Future<void> confirmDelete(
  BuildContext context, {
  required String title,
  required VoidCallback action,
}) async {
  await CustomDialog.show<void>(
    context,
    title: title,
    size: const Size(300, 250),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 20),
        const Text('Do you really want to delete?', style: ts18w5),
        const SizedBox(height: 10),
        const Text('This action cannot be undone!'),
        const SizedBox(height: 10),
        const Text('Prefer downloading a copy...'),
        const SizedBox(height: 20),
        CustomButton(
          radius: 8,
          onPressed: action,
          color: colorDarkRed,
          left: const Icon(Icons.delete, color: colorPrimaryWhite),
          right: const Text(
            'Permanently delete',
            style: TextStyle(color: colorPrimaryWhite),
          ),
        ),
      ],
    ),
  );
}

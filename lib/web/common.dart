/// MIT License
///
/// Copyright (c) 2021 Mitul Vaghamshi
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

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
  sessionInfo,
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

import 'package:flutter/material.dart';
import 'package:tendon_loader/modal/export.dart';

final ValueNotifier<Export?> clickNotifier = ValueNotifier<Export?>(null);

enum PopupAction {
  isClinician,
  download,
  delete,
  prescribe,
  history,
  darkMode,
  logout,
  settings,
}

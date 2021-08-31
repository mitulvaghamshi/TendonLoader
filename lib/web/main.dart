import 'package:flutter/material.dart';
import 'package:tendon_loader/app.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/web/app_state/app_state_widget.dart';

Future<void> main() async {
  await initApp();
  runApp(const AppStateWidget(child: TendonLoader()));
}

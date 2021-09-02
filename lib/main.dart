/// File: main.dart
/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';
import 'package:tendon_loader/app.dart';
import 'package:tendon_loader/utils/common.dart';

/// The entry point of the application for both the mobile only 
/// while, web provided with it's own main method. see [lib/web/main.dart].
///
/// The method is marked as [async] to perform basic but mandatory initialization,
/// by calling the top level [initApp] method which is responsible 
/// for the proper initialization of require componets including: [Firebase], [Hive].
///
/// [awaited] initialization causes slight [delay] in app [startup], but makes 
/// rest of the app life-cycle smoother and convenient.
/// 
/// Even if the prior initialization requirement, 
/// this app does not include any [splash screen] and navigate user to [login screen]
/// as soon as setup is complate. see [lib/utils/common/initApp()] method for more detail.
///
/// [NULL SAFETY IS HERE!!!]
/// [App] and all [dependencies] are fully [supported] with [null-safety] feature.
Future<void> main() async {
  await initApp(); // init must be done before starting the app.
  runApp(const TendonLoader()); // wait for system to complate init steps.
}

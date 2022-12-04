import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/app.dart';
import 'package:tendon_loader/common/models/chartdata.dart';
import 'package:tendon_loader/common/models/export.dart';
import 'package:tendon_loader/common/models/prescription.dart';
import 'package:tendon_loader/common/models/timestamp.dart';
import 'package:tendon_loader/firebase_options.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';
import 'package:tendon_loader/screens/settings/models/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initApp();
  runApp(TendonLoader(model: AppState()));
}

Future<void> _initApp() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseUIAuth.configureProviders(
      <AuthProvider<AuthListener, AuthCredential>>[EmailAuthProvider()]);
  if (kDebugMode) await _useEmulator();
  await Hive.initFlutter();
  Hive.registerAdapter(SettingsAdapter());
  Hive.registerAdapter(PrescriptionAdapter());
  Hive.registerAdapter(ExportAdapter());
  Hive.registerAdapter(ChartDataAdapter());
  Hive.registerAdapter(TimestampAdapter());
}

/// Development only, for Firebase Emulators.
/// Direct app to connect to local firebase emulator suite.
/// Learn more about initializing and running local emulators
/// at: [https://firebase.google.com/docs/emulator-suite]
Future<void> _useEmulator() async {
  const String host = '192.168.0.111';
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
}

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/firebase_options.dart';
import 'package:tendon_loader/shared/models/chartdata.dart';
import 'package:tendon_loader/shared/models/export.dart';
import 'package:tendon_loader/shared/models/patient.dart';
import 'package:tendon_loader/shared/models/prescription.dart';
import 'package:tendon_loader/shared/models/settings_state.dart';
import 'package:tendon_loader/shared/models/timestamp.dart';
import 'package:tendon_loader/shared/models/user_state.dart';
import 'package:tendon_loader/shared/utils/constants.dart';
import 'package:tendon_loader/shared/utils/empty.dart'
    if (dart.library.html) 'dart:html' show AnchorElement;

/// The user that is currently logged in to the app or web.
Patient? _currentUser;
Patient get patient => _currentUser!;
set patient(Patient? patient) => _currentUser = patient;

UserState? _userState;
UserState get userState => _userState!;
set userState(UserState? userState) => _userState = userState;

SettingsState? _settingsState;
SettingsState get settingsState => _settingsState!;
set settingsState(SettingsState? settings) => _settingsState = settings;

late final Box<bool> boxDarkMode;
late final Box<Export> boxExport;
late final Box<UserState> boxUserState;
late final Box<SettingsState> boxSettingsState;

Future<void> initApp() async {
  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Hive.registerAdapter(ExportAdapter());
  Hive.registerAdapter(UserStateAdapter());
  Hive.registerAdapter(ChartDataAdapter());
  Hive.registerAdapter(TimestampAdapter());
  Hive.registerAdapter(PrescriptionAdapter());
  Hive.registerAdapter(SettingsStateAdapter());
  boxExport = await Hive.openBox<Export>(keyExportBox);
  boxDarkMode = await Hive.openBox<bool>(keyDarkModeBox);
  boxUserState = await Hive.openBox<UserState>(keyUserStateBox);
  boxSettingsState = await Hive.openBox<SettingsState>(keySettingsStateBox);
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp],
    );
  }
  if (kDebugMode) await _useEmulator();
}

Future<void> saveExcel({List<int>? bytes, required String name}) async {
  if (!kIsWeb || bytes == null) return;
  final String data = 'data:application/zip;base64,${base64.encode(bytes)}';
  AnchorElement(href: data)
    ..setAttribute('download', name)
    ..click();
}

Future<int> tryUpload() async {
  int count = 0;
  if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
    for (final Export export in boxExport.values) {
      if (await export.upload()) count++;
    }
  }
  return count;
}

CollectionReference<Patient> get dbRoot {
  return FirebaseFirestore.instance.collection(keyBase).withConverter<Patient>(
      toFirestore: (Patient value, _) {
    return value.toMap();
  }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) {
    return Patient.fromJson(snapshot.reference);
  });
}

/// Development only, for Firebase Emulators.
/// Direct app to connect to local firebase emulator suite.
/// Learn more about initializing and running local emulators
/// at: [https://firebase.google.com/docs/emulator-suite]
Future<void> _useEmulator() async {
  const String host = '192.168.0.111'; // i.e '192.168.0.100'
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
}

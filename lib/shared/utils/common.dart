import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import 'package:tendon_loader/shared/widgets/alert_widget.dart';

/// [Firebase Emulators Suite] only.
/// Use this method to direct app to connect to local emulators suite.
/// Visit: [https://firebase.google.com/docs/emulator-suite] to learn more
/// about initializing and running local emulators.
Future<void> useEmulator() async {
  const String host = '192.168.0.56'; // i.e '192.168.0.100'
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
}

/// This represents the [User] that is currently logged in to the app or web.
/// It is specifically required to read new MVC or Exercise
/// prescriptions from the backend assigned by the Clinician.
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
  await useEmulator();
}

Future<void> saveExcel({List<int>? bytes, required String name}) async {
  if (kIsWeb) {
    AnchorElement(href: 'data:application/zip;base64,${base64.encode(bytes!)}')
      ..setAttribute('download', name)
      ..click();
  }
}

Future<bool?> tryUpload(BuildContext context) async {
  if (boxExport.isEmpty) return false;
  if ((await Connectivity().checkConnectivity()) != ConnectivityResult.none) {
    int count = 0;
    for (final Export export in boxExport.values) {
      if (await export.upload()) count++;
    }
    await AlertWidget.show<void>(
      context,
      title: 'Upload success!!!',
      content: Text(
        '$count file(s) submitted successfully!',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          color: Color(0xff3ddc85),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  return null;
}

CollectionReference<Patient> get dbRoot {
  return FirebaseFirestore.instance.collection(keyBase).withConverter<Patient>(
      toFirestore: (Patient value, _) {
    return value.toMap();
  }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) {
    return Patient.fromJson(snapshot.reference);
  });
}

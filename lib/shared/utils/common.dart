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
  await Firebase.initializeApp(options: _getOptions());
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
  await _useEmulator();
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

/// Development only, for Firebase Emulators.
/// Direct app to connect to local firebase emulator suite.
/// Learn more about initializing and running local emulators
/// at: [https://firebase.google.com/docs/emulator-suite]
Future<void> _useEmulator() async {
  const String host = '192.168.0.56'; // i.e '192.168.0.100'
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
}

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// await Firebase.initializeApp(options: _getOptions());
/// ```
FirebaseOptions _getOptions() {
  if (kIsWeb) {
    return const FirebaseOptions(
      apiKey: 'AIzaSyDwPG54_nK89jQ8y2smdDkfx4e9YlMOKzk',
      appId: '1:771464923209:web:d01140e155eeaee5615798',
      messagingSenderId: '771464923209',
      projectId: 'testflutterfirebaseapp',
      authDomain: 'testflutterfirebaseapp.firebaseapp.com',
      storageBucket: 'testflutterfirebaseapp.appspot.com',
    );
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      return const FirebaseOptions(
        apiKey: 'AIzaSyCVjcuo1wWxab_MFNOFYoDakN_iKUra5l4',
        appId: '1:771464923209:ios:27092ccc6d2daf6e615798',
        messagingSenderId: '771464923209',
        projectId: 'testflutterfirebaseapp',
        storageBucket: 'testflutterfirebaseapp.appspot.com',
        iosClientId:
            '771464923209-9vkhte6vcq905h9mdbu4mk1rctefk44c.apps.googleusercontent.com',
        iosBundleId: 'me.mitul.tendonLoader',
      );
    case TargetPlatform.android:
      throw UnsupportedError('FirebaseOptions not configured for android');
    case TargetPlatform.macOS:
      throw UnsupportedError('FirebaseOptions not configured for macOS');
    case TargetPlatform.fuchsia:
      throw UnsupportedError('FirebaseOptions not configured for fuchsia');
    case TargetPlatform.linux:
      throw UnsupportedError('FirebaseOptions not configured for linux');
    case TargetPlatform.windows:
      throw UnsupportedError('FirebaseOptions not configured for windows');
  }
}

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

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/timestamp.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/empty.dart'
    if (dart.library.html) 'dart:html' show AnchorElement;
import 'package:tendon_loader/utils/themes.dart';

/// [Firebase Emulators Suite] only.
/// Use this method to direct app to connect to local emulators suite.
/// Visit: [https://firebase.google.com/docs/emulator-suite] to learn more 
/// about initializing and running local emulators.
Future<void> useEmulator() async {
  const String host = 'host-ip-as-a-string'; // i.e '192.168.0.100'
  await FirebaseAuth.instance.useAuthEmulator(host, 10001);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 10002);
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
  await Firebase.initializeApp();
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
  // await useEmulator();
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
    await CustomDialog.show<void>(
      context,
      title: 'Upload success!!!',
      content: Text(
        '$count file(s) submitted successfully!',
        textAlign: TextAlign.center,
        style: tsG18B,
      ),
    );
  }
}

CollectionReference<Patient> get dbRoot {
  return FirebaseFirestore.instance.collection(keyBase).withConverter<Patient>(
      toFirestore: (Patient value, _) {
    return value.toMap();
  }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) {
    return Patient.fromJson(snapshot.reference);
  });
}

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
import 'package:tendon_loader/emulator.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/timestamp.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/screens/app_settings.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/screens/homescreen.dart';
import 'package:tendon_loader/screens/livedata/live_data.dart';
import 'package:tendon_loader/screens/login.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/screens/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/empty.dart' if (dart.library.html) 'dart:html' show AnchorElement;
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/webportal/homepage.dart';

late final Box<Export> boxExport; // app only
late final Box<UserState> boxUserState; // web and app
late final Box<SettingsState> boxSettingsState; // app only

Future<void> initializeApp() async {
  await Firebase.initializeApp();
  await useEmulator();
  await Hive.initFlutter();
  Hive.registerAdapter(UserStateAdapter());
  if (!kIsWeb) {
    Hive.registerAdapter(ExportAdapter());
    Hive.registerAdapter(ChartDataAdapter());
    Hive.registerAdapter(TimestampAdapter());
    Hive.registerAdapter(PrescriptionAdapter());
    Hive.registerAdapter(SettingsStateAdapter());
    boxExport = await Hive.openBox<Export>(keyExportBox);
    boxSettingsState = await Hive.openBox<SettingsState>(keySettingsStateBox);
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  }
  boxUserState = await Hive.openBox<UserState>(keyUserStateBox);
}

Map<String, WidgetBuilder> get routes => _routes;

final Map<String, WidgetBuilder> _routes = <String, WidgetBuilder>{
  Login.route: (_) => const Login(),
  LiveData.route: (_) => const LiveData(),
  HomePage.route: (_) => const HomePage(),
  HomeScreen.route: (_) => const HomeScreen(),
  NewMVCTest.route: (_) => const NewMVCTest(),
  MVCTesting.route: (_) => const MVCTesting(),
  AppSettings.route: (_) => const AppSettings(),
  NewExercise.route: (_) => const NewExercise(),
  ExerciseMode.route: (_) => const ExerciseMode(),
};

Route<T> buildRoute<T>(String routeName) {
  return PageRouteBuilder<T>(
    pageBuilder: (BuildContext context, __, ___) => _routes[routeName]!(context),
    transitionsBuilder: (_, Animation<double> animation, ___, Widget child) {
      return SlideTransition(
        position: animation.drive(Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.ease))),
        child: child,
      );
    },
  );
}

Future<void> signout() async {
  try {
    await FirebaseAuth.instance.signOut();
  } finally {}
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
      if (await export.upload(context)) count++;
    }
    await CustomDialog.show<void>(
      context,
      title: 'Upload success!!!',
      content: Text('$count file(s) submitted successfully!', textAlign: TextAlign.center, style: tsG18B),
    );
  }
}

CollectionReference<Patient> get dataStore => FirebaseFirestore.instance.collection(keyBase).withConverter<Patient>(
    toFirestore: (Patient value, _) => value.toMap(),
    fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) => Patient.fromJson(snapshot.reference));

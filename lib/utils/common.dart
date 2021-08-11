import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/main.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/empty.dart' if (dart.library.html) 'dart:html' show AnchorElement;
import 'package:tendon_loader/utils/themes.dart';

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

Future<void> signout() async {
  try {
    await FirebaseAuth.instance.signOut();
  } finally {}
}

CollectionReference<Patient> get dataStore => FirebaseFirestore.instance.collection(keyBase).withConverter<Patient>(
    toFirestore: (Patient value, _) => value.toMap(),
    fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) => Patient.fromJson(snapshot.reference));

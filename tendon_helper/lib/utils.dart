import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/anchor_element.dart'
    if (dart.library.html) 'dart:html' show AnchorElement;
import 'package:tendon_loader/export.dart';
import 'package:tendon_loader/main.dart';
import 'package:tendon_loader/patient.dart';

final CollectionReference<Patient> myQuery = FirebaseFirestore.instance
    .collection(keyBase)
    .withConverter<Patient>(
        fromFirestore: Patient.fromJson,
        toFirestore: (Patient patient, _) => <String, dynamic>{});

Future<void> uploadToFirebase(Patient patient) async {
  final List<String> list = files[patient.patientRef!.id]!;

  for (final String file in list) {
    final String json = await rootBundle.loadString(file);
    final Map<String, dynamic> map = jsonDecode(json) as Map<String, dynamic>;
    final Export export = Export.fromMap(map);
    await patient.exportRef?.add(export);
    debugPrint(export.userId);
  }
}

// Future<void> saveAsJson(Export export) async {
//   final Map<String, dynamic> map = export.toMapJson();

//   final String data = map.remove('"$keyExportData"').toString();

//   final String user =
//       '${export.userId}-${export.timestamp?.millisecondsSinceEpoch}'
//           .replaceAll('@', '');

//   if (kIsWeb) {
//     String encode(String value) =>
//         'data:application/zip;base64,${base64Encode(utf8.encode(value))}';

//     AnchorElement(href: encode(map.toString()))
//       ..setAttribute('download', '$user-user.json')
//       ..click();

//     AnchorElement(href: encode(data))
//       ..setAttribute('download', '$user-data.json')
//       ..click();
//   } else {
//     await (File('$user-user.json')..openWrite()).writeAsString(map.toString());
//     await (File('$user-data.json')..openWrite()).writeAsString(data);
//   }
// }

Future<void> saveAsSQL(Export export) async {
  final String exercise = export.toMapSql();

  String prescription = "";
  if (export.prescription != null) {
    prescription = export.prescription!.toMapJson(export.userId!);
  }

  // final String user = '$exID-${export.userId}'.replaceAll('@', '');

  if (kIsWeb) {
    String encode(String value) =>
        'data:application/zip;base64,${base64Encode(utf8.encode(value))}';

    AnchorElement(href: encode(exercise))
      ..setAttribute('download', '$exID-exe.sql')
      ..click();

    if (prescription.isNotEmpty) {
      AnchorElement(href: encode(prescription))
        ..setAttribute('download', '$exID-pre.sql')
        ..click();
    }
  } else {
    // await (File('$user-user.json')..openWrite()).writeAsString(map.toString());
    // await (File('$user-data.json')..openWrite()).writeAsString(mapData);
  }
}

const String keySets = 'sets';
const String keyReps = 'reps';
const String keySetRest = 'setRest';
const String keyHoldTime = 'holdTime';
const String keyRestTime = 'restTime';
const String keyTargetLoad = 'targetLoad';
const String keyMvcDuration = 'mvcDuration';

const String keyIsAdmin = 'isAdmin';
const String keyUserId = 'userId';
const String keyMvcValue = 'mvcValue';
const String keyPainScore = 'painScore';
const String keyIsTolerable = 'isTolerable';
const String keyTimeStamp = 'timeStamp';
const String keyExportData = 'exportData';
const String keyIsComplate = 'isComplate';
const String keyProgressorId = 'progressorId';
const String keyPrescription = 'prescription';

const String keyChartX = 'time';
const String keyChartY = 'load';

const String keyBase = 'TendonLoader';
const String keyExports = 'exports';

final Map<String, List<String>> files = <String, List<String>>{
  'alexscott@tendonloader.com': <String>[
    "alexscott@tendonloader.com-2023-05-03 00:26:33.668758.json",
  ],
  'kohlemerry@tendonloader.com': <String>[
    "kohlemerry@tendonloader.com-2023-05-03 00:28:07.248471.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:28:13.917522.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:28:16.291933.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:28:19.844349.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:28:22.003248.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:28:32.229792.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:28:34.390883.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:28:36.053207.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:28:38.234111.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:28:40.274885.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:28:42.421533.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:29:29.229817.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:29:31.433512.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:29:34.909948.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:29:37.443025.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:29:39.735580.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:29:42.095710.json",
    "kohlemerry@tendonloader.com-2023-05-03 00:29:44.392022.json",
  ],
  'megan@tendonloader.com': <String>[
    "megan@tendonloader.com-2023-05-03 00:30:11.552216.json",
    "megan@tendonloader.com-2023-05-03 00:30:14.258357.json",
    "megan@tendonloader.com-2023-05-03 00:30:16.033951.json",
    "megan@tendonloader.com-2023-05-03 00:30:17.540762.json",
    "megan@tendonloader.com-2023-05-03 00:30:19.139203.json",
    "megan@tendonloader.com-2023-05-03 00:30:21.127246.json",
    "megan@tendonloader.com-2023-05-03 00:30:23.203425.json",
  ],
  'mitul@gmail.com': <String>[
    "mitul@gmail.com-2023-05-03 00:30:29.454625.json",
    "mitul@gmail.com-2023-05-03 00:30:31.316087.json",
    "mitul@gmail.com-2023-05-03 00:30:32.520078.json",
    "mitul@gmail.com-2023-05-03 00:30:34.334364.json",
    "mitul@gmail.com-2023-05-03 00:30:35.838861.json",
    "mitul@gmail.com-2023-05-03 00:30:37.640536.json",
    "mitul@gmail.com-2023-05-03 00:30:39.561037.json",
    "mitul@gmail.com-2023-05-03 00:30:40.834501.json",
    "mitul@gmail.com-2023-05-03 00:30:42.655610.json",
    "mitul@gmail.com-2023-05-03 00:30:44.298423.json",
  ]
};

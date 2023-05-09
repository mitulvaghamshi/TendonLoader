import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final query = FirebaseFirestore.instance
    .collection('TendonLoader')
    .withConverter<Patient>(
        fromFirestore: (snapshot, _) => Patient.fromJson(snapshot.reference),
        toFirestore: (patient, _) => {});

@immutable
class Patient {
  const Patient({this.userRef, this.exportRef, this.prescriptionRef});

  factory Patient.fromJson(reference) {
    final exportRef = reference.collection(keyExports).withConverter<Export>(
          fromFirestore: Export.fromJson,
          toFirestore: (Export value, _) => value.toMap(),
        );

    final prescriptionRef = reference.withConverter<Prescription>(
      fromFirestore: Prescription.fromJson,
      toFirestore: (Prescription value, _) => value.toMap(),
    );

    return Patient(
      userRef: reference,
      exportRef: exportRef,
      prescriptionRef: prescriptionRef,
    );
  }

  final CollectionReference<Export>? exportRef;
  final DocumentReference<Prescription>? prescriptionRef;
  final DocumentReference<Map<String, dynamic>>? userRef;
}

class Prescription {
  Prescription({
    required this.sets,
    required this.reps,
    required this.setRest,
    required this.holdTime,
    required this.restTime,
    required this.targetLoad,
    required this.mvcDuration,
    this.isAdmin,
  });

  factory Prescription.fromJson(snapshot, _) =>
      Prescription.fromMap(snapshot.data()!);

  factory Prescription.fromMap(data) => Prescription(
      sets: int.parse(data[keySets].toString()),
      reps: int.parse(data[keyReps].toString()),
      setRest: int.parse(data[keySetRest].toString()),
      restTime: int.parse(data[keyRestTime].toString()),
      holdTime: int.parse(data[keyHoldTime].toString()),
      targetLoad: double.parse(data[keyTargetLoad].toString()),
      mvcDuration: int.parse(data[keyMvcDuration].toString()),
      isAdmin: data[keyIsAdmin] as bool?);

  final int sets;
  final int reps;
  final int setRest;
  final int holdTime;
  final int restTime;
  final int mvcDuration;
  final double targetLoad;
  bool? isAdmin;

  Map<String, dynamic> toMap() => {
        '"$keySets"': '"$sets"',
        '"$keyReps"': '"$reps"',
        '"$keySetRest"': '"$setRest"',
        '"$keyHoldTime"': '"$holdTime"',
        '"$keyRestTime"': '"$restTime"',
        '"$keyTargetLoad"': '"$targetLoad"',
        '"$keyMvcDuration"': '"$mvcDuration"',
        '"$keyIsAdmin"': '"$isAdmin"'
      };
}

class Export {
  Export({
    this.userId,
    this.mvcValue,
    this.painScore,
    this.isTolerable,
    this.reference,
    this.prescription,
    this.exportData,
    this.timestamp,
    this.isComplate,
    this.progressorId,
  });

  factory Export.fromJson(snapshot, _) {
    final data = snapshot.data()!;

    final isTolerable = data.containsKey(keyIsTolerable)
        ? data[keyIsTolerable] as String?
        : '---';

    final painScore = data.containsKey(keyPainScore)
        ? double.tryParse(data[keyPainScore].toString())
        : 0.0;

    final prescription = data.containsKey(keyPrescription)
        ? Prescription.fromMap(data[keyPrescription] as Map<String, dynamic>)
        : null;

    final exportData =
        List<Map<String, dynamic>>.from(data[keyExportData] as List<dynamic>)
            .map(ChartData.fromEntry)
            .toList();

    return Export(
      reference: snapshot.reference,
      userId: data[keyUserId] as String,
      isComplate: data[keyIsComplate] as bool,
      isTolerable: isTolerable,
      timestamp: data[keyTimeStamp] as Timestamp,
      progressorId: data[keyProgressorId] as String,
      mvcValue: double.tryParse(data[keyMvcValue].toString()),
      painScore: painScore,
      prescription: prescription,
      exportData: exportData,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        '"$keyUserId"': '"$userId"',
        '"$keyPainScore"': '"$painScore"',
        '"$keyTimeStamp"':
            '"${DateFormat('MMM dd, yyyy hh:mm a').format(timestamp?.toDate() ?? DateTime.now())}"',
        '"$keyIsTolerable"': '"$isTolerable"',
        '"$keyIsComplate"': '"$isComplate"',
        '"$keyProgressorId"': '"$progressorId"',
        if (isMVC)
          '"$keyMvcValue"': '"$mvcValue"'
        else
          '"$keyPrescription"': prescription?.toMap(),
        '"$keyExportData"': exportData!.map(_converter).toList()
      };

  String? userId;
  bool? isComplate;
  double? mvcValue;
  double? painScore;
  String? isTolerable;
  Timestamp? timestamp;
  String? progressorId;
  List<ChartData>? exportData;
  Prescription? prescription;
  DocumentReference<Map<String, dynamic>>? reference;

  bool get isMVC => mvcValue != null && prescription == null;
  Map<String, String> _converter(data) => {'"${data.time}"': '"${data.load}"'};
}

@immutable
class ChartData {
  const ChartData({this.time = 0, this.load = 0});

  factory ChartData.fromJson(data) =>
      ChartData.fromMap(jsonDecode(data) as Map<String, dynamic>);

  factory ChartData.fromMap(map) => ChartData(
        time: map[keyChartX] as double,
        load: map[keyChartY] as double,
      );

  factory ChartData.fromEntry(map) {
    final entry = map.entries.first;
    return ChartData(
      time: double.parse(entry.key),
      load: double.parse(entry.value.toString()),
    );
  }

  final double time;
  final double load;
}

// Exercise and MVC session data fields.
const String keySets = 'sets';
const String keyReps = 'reps';
const String keySetRest = 'setRest';
const String keyHoldTime = 'holdTime';
const String keyRestTime = 'restTime';
const String keyTargetLoad = 'targetLoad';
const String keyMvcDuration = 'mvcDuration';

// User (exercise/mvc) session data fields.
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
// Database fields, for (x,y) coordinate.
const String keyChartX = 'time';
const String keyChartY = 'load';

// Firestore root collection.
const String keyBase = 'TendonLoader';
const String keyExports = 'exports';

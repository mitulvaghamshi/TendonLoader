import 'dart:convert';

import 'package:archive/archive_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/utils/empty.dart' if (dart.library.html) 'dart:html' show AnchorElement;
import 'package:tendon_loader/web_portal/handler/excel_handler.dart';

part 'export.g.dart';

@HiveType(typeId: 2)
class Export extends HiveObject {
  Export({
    this.userId,
    this.mvcValue,
    this.reference,
    this.prescription,
    required this.timestamp,
    required this.isComplate,
    required this.exportData,
    required this.progressorId,
  });

  Export.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this(
            reference: snapshot.reference,
            userId: snapshot.data()![keyUserId] as String,
            mvcValue: double.tryParse(snapshot.data()![keyMvcValue].toString()),
            isComplate: snapshot.data()![keyIsComplate] as bool,
            timestamp: snapshot.data()![keyTimeStamp] as Timestamp,
            progressorId: snapshot.data()![keyProgressorId] as String,
            prescription: snapshot.data()!.containsKey(keyPrescription)
                ? Prescription.fromJson(snapshot.data()![keyPrescription] as Map<String, dynamic>)
                : null,
            exportData: List<ChartData>.from((snapshot.data()![keyExportData] as Map<String, dynamic>)
                .entries
                .map<ChartData>((MapEntry<String, dynamic> e) => ChartData.fromEntry(e))));
  // ..sort((ChartData a, ChartData b) => a.time!.compareTo(b.time!)));
  // remove sorting

  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final bool isComplate;
  @HiveField(2)
  final double? mvcValue;
  @HiveField(3)
  final Timestamp timestamp;
  @HiveField(4)
  final String progressorId;
  @HiveField(5)
  final List<ChartData> exportData;
  @HiveField(6)
  final Prescription? prescription;
  @HiveField(7)
  final DocumentReference<Map<String, dynamic>>? reference;

  bool get isMVC => mvcValue != null && prescription == null;
  String get dateTime => DateFormat(keyDateTimeFormat).format(timestamp.toDate());
  String get fileName => '$dateTime $userId ${isMVC ? 'MVCTest' : 'Exercise'}.xlsx'.replaceAll(RegExp(r'[\s:]'), '_');

  Map<String, dynamic> toMap() {
    final Map<String, double> exportDataMap = <String, double>{};
    for (final ChartData data in exportData) {
      exportDataMap[data.time!.toString()] = data.load!;
    }
    return <String, dynamic>{
      keyUserId: userId,
      if (isMVC) keyMvcValue: mvcValue,
      keyTimeStamp: timestamp,
      keyIsComplate: isComplate,
      keyExportData: exportDataMap,
      keyProgressorId: progressorId,
      if (!isMVC) keyPrescription: prescription?.toMap(),
    };
  }

  Future<bool> upload(BuildContext context) async {
    late bool result;
    try {
      await AppStateScope.of(context).currentUser!.exportRef!.doc().set(this);
      result = true;
    } on FirebaseException {
      result = false;
    }
    return Future<bool>.value(result);
  }

  // long task
  Future<void> download() async {
    final Archive archive = Archive();
    archive.addFile(generateExcel(this));
    AnchorElement(href: 'data:application/zip;base64,${base64.encode(ZipEncoder().encode(archive)!)}')
      ..setAttribute('download', '$fileName.zip')
      ..click();
  }

  Future<void> deleteExport() async {
    await reference!.delete();
  }
}

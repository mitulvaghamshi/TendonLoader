import 'package:archive/archive_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/utils/downloader.dart';
import 'package:tendon_loader/utils/extension.dart';
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
            exportData: List<Map<String, dynamic>>.from(snapshot.data()![keyExportData] as List<dynamic>)
                .map((Map<String, dynamic> map) => ChartData.fromEntry(map.entries.first))
                .toList());

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
    return <String, dynamic>{
      keyUserId: userId,
      keyTimeStamp: timestamp,
      keyIsComplate: isComplate,
      keyProgressorId: progressorId,
      if (isMVC) keyMvcValue: mvcValue,
      if (!isMVC) keyPrescription: prescription?.toMap(),
      keyExportData: exportData.map((ChartData e) => e.toMap()).toList(),
    };
  }

  Future<bool> upload(BuildContext context) async {
    try {
      return context.model.currentUser!.exportRef!.doc().set(this).then((_) => delete()).then((_) => true);
    } on FirebaseException {
      return false;
    }
  }

  // long task
  Future<void> download() async =>
      Downloader(bytes: ZipEncoder().encode(Archive()..addFile(generateExcel(this)))).download(name: '$fileName.zip');

  Future<void> cloudDelete() async => reference!.delete();
}

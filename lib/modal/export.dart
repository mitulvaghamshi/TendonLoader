import 'package:archive/archive_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tendon_loader/handlers/download_handler.dart';
import 'package:tendon_loader/handlers/excel_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/utils/constant/keys.dart';
import 'package:tendon_loader/utils/extension.dart';

part 'export.g.dart';

@HiveType(typeId: 2)
class Export extends HiveObject {
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

  Export.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this(
            reference: snapshot.reference,
            userId: snapshot.data()![keyUserId] as String,
            isComplate: snapshot.data()![keyIsComplate] as bool,
            isTolerable:
                snapshot.data()!.containsKey(keyIsTolerable) ? snapshot.data()![keyIsTolerable] as String? : '---',
            timestamp: snapshot.data()![keyTimeStamp] as Timestamp,
            progressorId: snapshot.data()![keyProgressorId] as String,
            mvcValue: double.tryParse(snapshot.data()![keyMvcValue].toString()),
            painScore: snapshot.data()!.containsKey(keyPainScore)
                ? double.tryParse(snapshot.data()![keyPainScore].toString())
                : 0,
            prescription: snapshot.data()!.containsKey(keyPrescription)
                ? Prescription.fromJson(snapshot.data()![keyPrescription] as Map<String, dynamic>)
                : null,
            exportData: List<Map<String, dynamic>>.from(snapshot.data()![keyExportData] as List<dynamic>)
                .map((Map<String, dynamic> map) => ChartData.fromEntry(map.entries.first))
                .toList());

  @HiveField(0)
  String? userId;
  @HiveField(1)
  bool? isComplate;
  @HiveField(2)
  double? mvcValue;
  @HiveField(3)
  double? painScore;
  @HiveField(4)
  String? isTolerable;
  @HiveField(5)
  Timestamp? timestamp;
  @HiveField(6)
  String? progressorId;
  @HiveField(7)
  List<ChartData>? exportData;
  @HiveField(8)
  Prescription? prescription;
  @HiveField(9)
  DocumentReference<Map<String, dynamic>>? reference;

  bool get isMVC => mvcValue != null && prescription == null;
  String get dateTime => DateFormat(keyDateTimeFormat).format(timestamp!.toDate());
  String get fileName => '$dateTime $userId ${isMVC ? 'MVCTest' : 'Exercise'}.xlsx'.replaceAll(RegExp(r'[\s:]'), '_');

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      keyUserId: userId,
      keyPainScore: painScore,
      keyTimeStamp: timestamp,
      keyIsTolerable: isTolerable,
      keyIsComplate: isComplate,
      keyProgressorId: progressorId,
      if (isMVC) keyMvcValue: mvcValue,
      if (!isMVC) keyPrescription: prescription?.toMap(),
      keyExportData: exportData!.map((ChartData e) => e.toMap()).toList(),
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

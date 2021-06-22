import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/handler/excel_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/prescription.dart';

class Export {
  const Export({
    this.userId,
    this.mvcValue,
    this.reference,
    this.prescription,
    required this.timestamp,
    required this.isComplate,
    required this.exportData,
    required this.progressorId,
  });

  Export.fromMap(DocumentSnapshot<Map<String, dynamic>> snapshot)
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
                .map<ChartData>((MapEntry<String, dynamic> e) => ChartData.fromEntry(e)))
              ..sort((ChartData a, ChartData b) => a.time!.compareTo(b.time!)));

  final String? userId;
  final bool isComplate;
  final double? mvcValue;
  final Timestamp timestamp;
  final String progressorId;
  final List<ChartData> exportData;
  final Prescription? prescription;
  final DocumentReference<Map<String, dynamic>>? reference;

  bool get isMVC => mvcValue != null && prescription == null;
  String get title => DateFormat(keyDateTimeFormat).format(timestamp.toDate());
  String get fileName =>
      title.replaceAll(RegExp(r'[\s:]'), '-') + '_${userId}_${isMVC ? 'MVCTest' : 'Exercise'}_$progressorId.xlsx';

  // long task
  Future<void> download() async {
    generateExcel(this);
  }

  Future<void> delete() async {
    await reference!.delete();
  }
}

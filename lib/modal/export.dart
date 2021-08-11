import 'package:archive/archive_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/constants.dart';
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
      await context.patient.exportRef!.doc().set(this);
      await delete();
      return true;
    } on FirebaseException {
      return false;
    }
  }

  // long task
  Future<void> download() async {
    await saveExcel(name: '$fileName.zip', bytes: ZipEncoder().encode(Archive()..addFile(toArchivedExcel())));
  }

  ArchiveFile toArchivedExcel() {
    final Workbook _book = Workbook();
    final Worksheet _sheet = _book.worksheets[0];

    const int c4 = 4, c5 = 5;
    _sheet
      ..getRangeByIndex(1, 1).setText('TIME [s]')
      ..getRangeByIndex(1, 2).setText('LOAD [Kg]')
      ..getRangeByIndex(1, c4).text = 'Date:'
      ..getRangeByIndex(1, c5).dateTime = timestamp!.toDate()
      ..getRangeByIndex(1, c5).numberFormat = 'yyyy-mmm-dd, dddd'
      ..getRangeByIndex(2, c4).text = 'Time:'
      ..getRangeByIndex(2, c5).dateTime = timestamp!.toDate()
      ..getRangeByIndex(2, c5).numberFormat = 'hh:mm:ss AM/PM'
      ..getRangeByIndex(3, c4).text = 'User ID:'
      ..getRangeByIndex(3, c5).text = userId
      ..getRangeByIndex(4, c4).text = 'Progressor ID:'
      ..getRangeByIndex(4, c5).text = progressorId
      ..getRangeByIndex(6, c4).text = 'Pain Score:'
      ..getRangeByIndex(6, c5).text = painScore?.toString() ?? '---'
      ..getRangeByIndex(7, c4).text = 'Pain Tolerable?:'
      ..getRangeByIndex(7, c5).text = isTolerable
      ..autoFitColumn(c4)
      ..autoFitColumn(c5);

    if (!isMVC) {
      _sheet
        ..getRangeByIndex(9, c4).text = 'Exercise Info'
        ..getRangeByIndex(10, c4).text = 'Target Load [Kg]'
        ..getRangeByIndex(10, c5).number = prescription!.targetLoad
        ..getRangeByIndex(11, c4).text = 'Hold Time [Sec]'
        ..getRangeByIndex(11, c5).number = prescription!.holdTime.toDouble()
        ..getRangeByIndex(12, c4).text = 'Rest Time [Sec]'
        ..getRangeByIndex(12, c5).number = prescription!.restTime.toDouble()
        ..getRangeByIndex(13, c4).text = 'Sets [#]'
        ..getRangeByIndex(13, c5).number = prescription!.sets.toDouble()
        ..getRangeByIndex(14, c4).text = 'Reps [#]'
        ..getRangeByIndex(14, c5).number = prescription!.reps.toDouble();
    }

    int i = 1;
    for (final ChartData chartData in exportData!) {
      _sheet
        ..getRangeByIndex(++i, 1).number = chartData.time
        ..getRangeByIndex(i, 2).number = chartData.load;
    }

    final InputStream _stream = InputStream(_book.saveAsStream());
    final ArchiveFile _file = ArchiveFile.stream(fileName, _stream.length, _stream);
    _book.dispose();

    return _file;
  }
}

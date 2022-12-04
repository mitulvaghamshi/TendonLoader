import 'package:archive/archive_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/excel/save_excel.dart';
import 'package:tendon_loader/common/models/chartdata.dart';
import 'package:tendon_loader/common/models/patient.dart';
import 'package:tendon_loader/common/models/prescription.dart';

part 'export.g.dart';

@HiveType(typeId: 3)
class Export extends HiveObject {
  Export({
    this.reference,
    this.userId,
    this.mvcValue,
    this.painScore,
    this.isTolerable,
    this.prescription,
    this.timestamp,
    this.isComplate,
    this.progressorId,
    this.exportData,
  });

  factory Export.fromJson(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    final Map<String, dynamic> data = snapshot.data()!;
    return Export(
      reference: snapshot.reference,
      userId: data[DataKeys.userId].toString(),
      isComplate: data[DataKeys.isComplate] as bool,
      timestamp: data[DataKeys.timeStamp] as Timestamp,
      isTolerable: data[DataKeys.isTolerable].toString(),
      progressorId: data[DataKeys.progressorId].toString(),
      mvcValue: double.tryParse(data[DataKeys.mvcValue].toString()),
      painScore: double.tryParse(data[DataKeys.painScore].toString()),
      prescription: data.containsKey(DataKeys.prescription)
          ? Prescription.fromMap(
              data[DataKeys.prescription] as Map<String, dynamic>)
          : null,
      exportData: List<Map<String, dynamic>>.from(
              data[DataKeys.exportData] as List<dynamic>)
          .map(ChartData.fromEntry),
    );
  }

  DocumentReference<Map<String, dynamic>>? reference;

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
  Prescription? prescription;
  @HiveField(8)
  Iterable<ChartData>? exportData;
}

extension ExExport on Export {
  bool get isMVC => mvcValue != null && prescription == null;
  String get type => isMVC ? 'MVC Test' : 'Exercise';
  String get status => isComplate! ? 'Complete' : 'Incomplete';
  String get title => '$type $status';
  String get dateTime => DateFormat(dateFormat).format(timestamp!.toDate());
  String get fileName => '$dateTime $title.xlsx';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      DataKeys.userId: userId,
      DataKeys.painScore: painScore,
      DataKeys.timeStamp: timestamp,
      DataKeys.isTolerable: isTolerable,
      DataKeys.isComplate: isComplate,
      DataKeys.progressorId: progressorId,
      if (isMVC)
        DataKeys.mvcValue: mvcValue
      else
        DataKeys.prescription: prescription?.toMap(),
      DataKeys.exportData: exportData!.map(_converter),
    };
  }

  ArchiveFile toExcelSheet() => excelSheet;

  Future<bool> upload() async {
    try {
      if (userId == null) throw 'Invalid patient id!';
      final Patient patient = Patient.of(userId!);
      await patient.exportRef!.doc().set(this);
      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<void> download() async {
    await saveExcel(
      name: '$fileName.zip',
      bytes: ZipEncoder().encode(Archive()..addFile(excelSheet)),
    );
  }
}

extension on Export {
  // Datetime format
  String get dateFormat => 'MMM dd, yyyy hh:mm a';

  Map<String, double> _converter(ChartData data) =>
      <String, double>{'${data.time}': data.load};

  ArchiveFile get excelSheet {
    final Workbook book = Workbook();
    final Worksheet sheet = book.worksheets[0];
    const int c4 = 4, c5 = 5;
    sheet
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
      sheet
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
      sheet
        ..getRangeByIndex(++i, 1).number = chartData.time
        ..getRangeByIndex(i, 2).number = chartData.load;
    }

    final InputStream stream = InputStream(book.saveAsStream());
    final ArchiveFile file =
        ArchiveFile.stream(fileName, stream.length, stream);
    book.dispose();
    return file;
  }
}

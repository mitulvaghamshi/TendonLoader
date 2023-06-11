import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tendon_loader/chart_data.dart';
import 'package:tendon_loader/prescription.dart';
import 'package:tendon_loader/utils.dart';

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

  factory Export.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
          SnapshotOptions? _) =>
      Export.fromMap(snapshot.data()!)..reference = snapshot.reference;

  factory Export.fromMap(Map<String, dynamic> data) {
    final String? isTolerable = data.containsKey(keyIsTolerable)
        ? data[keyIsTolerable] as String?
        : '---';

    final double? painScore = data.containsKey(keyPainScore)
        ? double.tryParse(data[keyPainScore].toString())
        : 0.0;

    // final bool isComplete = (data[keyIsComplate] as String) == 'true';

    // "Timestamp(seconds=1630433224, nanoseconds=18288000)",
    // final Map<String, dynamic> timeStampMap =
    //     data[keyTimeStamp] as Map<String, dynamic>;
    // final Timestamp timeStamp = Timestamp(
    //   int.parse(timeStampMap['seconds'] as String),
    //   int.parse(timeStampMap['nanoseconds'] as String),
    // );

    final Prescription? prescription = data.containsKey(keyPrescription)
        ? Prescription.fromMap(data[keyPrescription] as Map<String, dynamic>)
        : null;

    final List<ChartData> exportData =
        List<Map<String, dynamic>>.from(data[keyExportData] as List<dynamic>)
            .map(ChartData.fromEntry)
            .toList();

    return Export(
      userId: data[keyUserId] as String,
      // isComplate: isComplete,
      isComplate: data[keyIsComplate] as bool,
      isTolerable: isTolerable,
      // timestamp: timeStamp,
      timestamp: data[keyTimeStamp] as Timestamp,
      progressorId: data[keyProgressorId] as String,
      mvcValue: double.tryParse(data[keyMvcValue].toString()),
      painScore: painScore,
      prescription: prescription,
      exportData: exportData,
    );
  }

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

  Map<String, dynamic> _converter(ChartData data) =>
      <String, dynamic>{data.time.toString(): data.load};

  Map<String, dynamic> toMap() => <String, dynamic>{
        keyUserId: userId,
        keyPainScore: painScore,
        keyTimeStamp: timestamp,
        keyIsTolerable: isTolerable,
        keyIsComplate: isComplate,
        keyProgressorId: progressorId,
        if (isMVC)
          keyMvcValue: mvcValue
        else
          keyPrescription: prescription?.toMap(),
        keyExportData: exportData!.map(_converter).toList()
      };
}

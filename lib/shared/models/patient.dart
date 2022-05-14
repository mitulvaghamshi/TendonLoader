import 'package:archive/archive_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/shared/models/export.dart';
import 'package:tendon_loader/shared/models/prescription.dart';
import 'package:tendon_loader/shared/utils/common.dart';
import 'package:tendon_loader/shared/utils/constants.dart';

part 'patient.g.dart';

@HiveType(typeId: 4)
class Patient extends HiveObject {
  Patient({
    this.exports,
    this.userRef,
    this.exportRef,
    this.prescription,
    this.prescriptionRef,
  });

  Patient.of(String id)
      : this.fromJson(FirebaseFirestore.instance.doc('/$keyBase/$id'));

  Patient.fromJson(DocumentReference<Map<String, dynamic>> reference)
      : this(
          userRef: reference,
          exportRef: _exportsRef(reference),
          prescriptionRef: _prescriptionRef(reference),
        );

  @HiveField(0)
  final List<Export>? exports;
  @HiveField(1)
  final Prescription? prescription;
  @HiveField(2)
  final CollectionReference<Export>? exportRef;
  @HiveField(3)
  final DocumentReference<Prescription>? prescriptionRef;
  @HiveField(4)
  final DocumentReference<Map<String, dynamic>>? userRef;

  static CollectionReference<Export> _exportsRef(
      DocumentReference<Map<String, dynamic>> ref) {
    return ref.collection(keyExports).withConverter<Export>(
        toFirestore: (Export value, _) {
      return value.toMap();
    }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) {
      return Export.fromJson(snapshot);
    });
  }

  static DocumentReference<Prescription> _prescriptionRef(
      DocumentReference<Map<String, dynamic>> ref) {
    return ref.withConverter<Prescription>(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) {
      return Prescription.fromJson(snapshot.data()!);
    }, toFirestore: (Prescription value, _) {
      return value.toMap();
    });
  }

  String get id => userRef!.id;
  String get avatar => id[0].toUpperCase();
  String get exportCount => 'Total ${exports?.length} '
      'item${exports?.length == 1 ? '' : 's'} found';

  Future<Patient> fetch({bool? withExports = false}) async {
    final DocumentSnapshot<Prescription> kPrescription =
        await prescriptionRef!.get();
    List<Export>? kList;
    if (withExports!) {
      final QuerySnapshot<Export> kExports =
          await exportRef!.orderBy(keyTimeStamp, descending: true).get();
      kList = kExports.docs
          .map((QueryDocumentSnapshot<Export> e) => e.data())
          .toList();
    }
    return Patient(
      exports: kList,
      userRef: userRef,
      exportRef: exportRef,
      prescriptionRef: prescriptionRef,
      prescription: kPrescription.data(),
    );
  }

  Map<String, dynamic> toMap() => prescription!.toMap();

  // long task
  Future<void> download() async {
    final Archive kArchive = Archive();
    for (final Export export in exports!) {
      kArchive.addFile(export.toExcelSheet());
    }
    await saveExcel(name: '$id.zip', bytes: ZipEncoder().encode(kArchive));
  }

  Future<void> deleteAll() async {
    for (final Export export in exports!) {
      await export.reference!.delete();
    }
  }
}

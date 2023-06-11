import 'package:archive/archive_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/excel/save_excel.dart';
import 'package:tendon_loader/common/models/export.dart';
import 'package:tendon_loader/common/models/prescription.dart';

class Patient {
  Patient({this.reference, this.prescriptionRef, this.exportRef});

  factory Patient.of(String id) => Patient._(
      FirebaseFirestore.instance.doc('/${DataKeys.rootCollection}/$id'));

  factory Patient.fromJson(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? _) {
    return Patient._(snapshot.reference);
  }

  factory Patient._(DocumentReference<Map<String, dynamic>> reference) {
    final DocumentReference<Prescription> prescriptionRef =
        reference.withConverter<Prescription>(
            fromFirestore: Prescription.fromJson,
            toFirestore: (value, _) => value.toMap());

    final CollectionReference<Export> exportRef = reference
        .collection(DataKeys.exportsCollection)
        .withConverter<Export>(
            fromFirestore: Export.fromJson,
            toFirestore: (value, _) => value.toMap());

    return Patient(
      reference: reference,
      prescriptionRef: prescriptionRef,
      exportRef: exportRef,
    );
  }

  Prescription? prescription;
  final DocumentReference<Map<String, dynamic>>? reference;
  final DocumentReference<Prescription>? prescriptionRef;
  final CollectionReference<Export>? exportRef;
}

extension ExPatient on Patient {
  String get id => reference!.id;

  Future<void> download() async {
    final QuerySnapshot<Export> query = await exportRef!.get();
    final Iterable<ArchiveFile> iterable =
        query.docs.map<ArchiveFile>((e) => e.data().toExcelSheet());
    final Archive archive = Archive();
    iterable.forEach(archive.addFile);
    await saveExcel(name: '$id.zip', bytes: ZipEncoder().encode(archive));
  }

  Future<void> delete() async {
    final QuerySnapshot<Export> query = await exportRef!.get();
    query.docs.map((e) => e.reference.delete());
    await reference!.delete();
  }

  Map<String, dynamic> toMap() {
    if (prescription == null) throw 'Prescription is null!';
    return prescription!.toMap();
  }
}

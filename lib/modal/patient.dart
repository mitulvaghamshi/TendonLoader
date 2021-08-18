import 'package:archive/archive_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/webportal/export_tile.dart';

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

  Patient.fromJson(DocumentReference<Map<String, dynamic>> ref)
      : this(
          userRef: ref,
          exportRef: _exportsRef(ref),
          prescriptionRef: _prescriptionRef(ref),
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

  String get childCount => 'Total ${exports?.length} '
      'item${exports?.length == 1 ? '' : 's'} submitted';

  Iterable<Widget> exportTiles({
    String? filter,
    required Future<void> Function(VoidCallback) onDelete,
  }) {
    Iterable<Export>? filtered;

    if (filter != null) {
      filtered = exports!.where((Export export) {
        return export.fileName.toLowerCase().contains(filter.toLowerCase());
      });
    }
    return (filtered ?? exports)!.map((Export export) {
      return ExportTile(
        export: export,
        onDelete: () async => onDelete(
          () async => export.reference!.delete().then((_) {
            exports!.remove(export);
          }),
        ),
      );
    });
  }

  Future<Patient> fetch() async {
    final DocumentSnapshot<Prescription> _prescription =
        await prescriptionRef!.get();

    final QuerySnapshot<Export> _exports =
        await exportRef!.orderBy(keyTimeStamp, descending: true).get();

    final List<Export> _list = _exports.docs
        .map((QueryDocumentSnapshot<Export> e) => e.data())
        .toList();

    return Patient(
      exports: _list,
      userRef: userRef,
      exportRef: exportRef,
      prescriptionRef: prescriptionRef,
      prescription: _prescription.data(),
    );
  }

  Map<String, dynamic> toMap() => prescription!.toMap();

  // long task
  Future<void> download() async {
    final Archive _archive = Archive();
    for (final Export export in exports!) {
      _archive.addFile(export.toArchivedExcel());
    }
    await saveExcel(name: '$id.zip', bytes: ZipEncoder().encode(_archive));
  }

  Future<void> deleteAll() async {
    for (final Export export in exports!) {
      await export.reference!.delete();
    }
    exports!.clear();
  }

  Future<void> prescribe(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => CustomDialog(title: id, content: NewExercise(user: this)),
    );
  }
}

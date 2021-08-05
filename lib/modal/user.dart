import 'package:archive/archive_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/handlers/download_handler.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/screens/web/export_tile.dart';
import 'package:tendon_loader/utils/keys.dart';

part 'user.g.dart';

@HiveType(typeId: 4)
class User extends HiveObject {
  User({
    this.exports,
    this.userRef,
    this.exportRef,
    this.prescription,
    this.prescriptionRef,
  });

  User.of(String id) : this.fromJson(FirebaseFirestore.instance.doc('/$keyBase/$id'));

  User.fromJson(DocumentReference<Map<String, dynamic>> ref)
      : this(userRef: ref, exportRef: _exportsRef(ref), prescriptionRef: _prescriptionRef(ref));

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

  String get id => userRef!.id;
  String get avatar => id[0].toUpperCase();
  String get childCount => '${exports?.length} export${exports?.length == 1 ? '' : 's'} found.';

  Iterable<Widget> exportTiles(String? filter) {
    Iterable<Export>? filtered;
    if (filter != null) filtered = exports!.where((Export export) => export.fileName.toLowerCase().contains(filter));
    return (filtered ?? exports)!.map((Export export) => ExportTile(
        export: export, onDelete: () async => export.reference!.delete().then((_) => exports!.remove(export))));
  }

  static CollectionReference<Export> _exportsRef(DocumentReference<Map<String, dynamic>> ref) =>
      ref.collection(keyExports).withConverter<Export>(
          toFirestore: (Export value, SetOptions? options) => value.toMap(),
          fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) =>
              Export.fromJson(snapshot));

  static DocumentReference<Prescription> _prescriptionRef(DocumentReference<Map<String, dynamic>> ref) =>
      ref.withConverter<Prescription>(
          fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) =>
              Prescription.fromJson(snapshot.data()!),
          toFirestore: (Prescription value, _) => value.toMap());

  Future<User> fetch() async {
    final DocumentSnapshot<Prescription> _prescription = await prescriptionRef!.get();
    final QuerySnapshot<Export> _exports = await exportRef!.get();
    final List<Export> _list = _exports.docs.map((QueryDocumentSnapshot<Export> e) => e.data()).toList();
    return User(
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
      _archive.addFile(export.zipExcel());
    }
    await Downloader(bytes: ZipEncoder().encode(_archive)).download(name: '$id.zip');
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

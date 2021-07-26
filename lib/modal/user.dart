import 'package:archive/archive_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/handlers/download_handler.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/screens/web/left_panel/export_tile.dart';
import 'package:tendon_loader/utils/constant/keys.dart';

part 'user.g.dart';

@HiveType(typeId: 4)
@JsonSerializable(explicitToJson: true, createToJson: true, ignoreUnannotated: true)
class User extends HiveObject {
  User({
    this.exports,
    this.reference,
    this.exportRef,
    this.prescription,
    this.prescriptionRef,
  });

  User.of(String id) : this.fromJson(FirebaseFirestore.instance.doc('/$keyBase/$id'));

  User.fromJson(DocumentReference<Map<String, dynamic>> reference)
      : this(
            reference: reference,
            prescriptionRef: reference.withConverter<Prescription>(
                fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
              return Prescription.fromJson(snapshot.data()!);
            }, toFirestore: (Prescription value, SetOptions? options) {
              return value.toMap();
            }),
            exportRef: reference.collection(keyExports).withConverter<Export>(
                toFirestore: (Export value, SetOptions? options) {
              return value.toMap();
            }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
              return Export.fromJson(snapshot);
            }));

  @HiveField(0)
  @JsonKey(ignore: true)
  final List<Export>? exports;
  @HiveField(1)
  @JsonKey(ignore: true)
  final Prescription? prescription;
  @HiveField(2)
  final CollectionReference<Export>? exportRef;
  @HiveField(3)
  final DocumentReference<Prescription>? prescriptionRef;
  @HiveField(4)
  final DocumentReference<Map<String, dynamic>>? reference;

  String get id => reference!.id;
  String get avatar => id[0].toUpperCase();
  String get childCount => '${exports?.length} export${exports?.length == 1 ? '' : 's'} found.';

  Iterable<Widget> exportTiles() => exports!.map((Export export) => ExportTile(
      export: export, onDelete: () async => export.reference!.delete().then((_) => exports!.remove(export))));

  Future<User> fetch() async {
    final DocumentSnapshot<Prescription> _prescription = await prescriptionRef!.get();
    final QuerySnapshot<Export> _exports = await exportRef!.get();
    final List<Export> _list = _exports.docs.map((QueryDocumentSnapshot<Export> e) => e.data()).toList();
    return User(
      exports: _list,
      reference: reference,
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

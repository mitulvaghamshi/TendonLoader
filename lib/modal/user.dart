import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/web_portal/handler/excel_handler.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/web_portal/custom/export_list_item.dart';

part 'user.g.dart';

@HiveType(typeId: 4)
@JsonSerializable(explicitToJson: true, createToJson: true, ignoreUnannotated: true)
class User extends HiveObject {
  User({
    this.exports,
    this.prescription,
    this.userRef,
    this.exportRef,
    this.prescriptionRef,
  });

  User.of(String id) : this.fromJson(FirebaseFirestore.instance.doc('/$keyBase/$id'));

  User.fromJson(DocumentReference<Map<String, dynamic>> reference)
      : this(
            userRef: reference,
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
  final DocumentReference<Map<String, dynamic>>? userRef;

  String get id => userRef!.id;
  String get avatar => id[0].toUpperCase();
  String get childCount => '${exports?.length} export${exports?.length == 1 ? '' : 's'} found.';
  Iterable<Widget> get exportTiles => exports!.map((Export export) => ExportListItem(export: export));

  Future<User> fetch() async {
    final DocumentSnapshot<Prescription> _prescription = await prescriptionRef!.get();
    final QuerySnapshot<Export> _exports = await exportRef!.get();
    final List<Export> _list = _exports.docs.map((QueryDocumentSnapshot<Export> e) => e.data()).toList();
    return User(
      exports: _list,
      prescription: _prescription.data(),
      exportRef: exportRef,
      userRef: userRef,
      prescriptionRef: prescriptionRef,
    );
  }

  Map<String, dynamic> toMap() {
    return prescription!.toMap();
  }

  Future<void> download() async {
    exports!.forEach(generateExcel);
  }

  Future<void> deleteAllExports() async {
    for (final Export export in exports!) {
      await export.deleteExport();
    }
    exports!.clear();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/handler/excel_handler.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/web_portal/export_list_item.dart';

@immutable
class User {
  const User({
    required this.userRef,
    required this.exportRef,
    required this.prescriptionRef,
    this.prescription,
    this.exports,
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
              return <String, Object>{};
            }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
              return Export.fromMap(snapshot);
            }));

  final List<Export>? exports;
  final Prescription? prescription;
  final CollectionReference<Export> exportRef;
  final DocumentReference<Prescription> prescriptionRef;
  final DocumentReference<Map<String, dynamic>> userRef;

  static CollectionReference<User> get instance {
    return FirebaseFirestore.instance.collection(keyBase).withConverter<User>(
        toFirestore: (User value, SetOptions? options) {
      return <String, Object>{};
    }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
      return User.fromJson(snapshot.reference);
    });
  }

  String get id => userRef.id;
  String get avatar => id[0].toUpperCase();
  String get childCount => '${exports?.length} export${exports?.length == 1 ? '' : 's'} found.';
  Iterable<Widget> get exportTiles => exports!.map((Export export) => ExportListItem(export: export));

  Future<User> fetch() async {
    final DocumentSnapshot<Prescription> _prescription = await prescriptionRef.get();
    final QuerySnapshot<Export> _exports = await exportRef.get();
    final List<Export> _list = _exports.docs.map((QueryDocumentSnapshot<Export> e) => e.data()).toList();
    return User(
      exports: _list,
      prescription: _prescription.data(),
      exportRef: exportRef,
      userRef: userRef,
      prescriptionRef: prescriptionRef,
    );
  }

  Future<void> download() async {
    exports!.forEach(generateExcel);
  }
}

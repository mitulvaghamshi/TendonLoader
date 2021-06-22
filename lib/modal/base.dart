import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/modal/export.dart';

@immutable
class Base {
  const Base({required this.export, required this.reference});

  Base.fromJson(DocumentReference<Map<String, dynamic>> reference)
      : this(
            reference: reference,
            export: reference.collection(keyExports).withConverter<Export>(
                toFirestore: (Export value, SetOptions? options) {
              return <String, Object>{};
            }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
              return Export.fromMap(snapshot);
            }));

  final CollectionReference<Export> export;
  final DocumentReference<Map<String, dynamic>> reference;

  static CollectionReference<Base> get instance {
    return FirebaseFirestore.instance.collection(keyBase).withConverter<Base>(
        toFirestore: (Base value, SetOptions? options) {
      return <String, Object>{};
    }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
      return Base.fromJson(snapshot.reference);
    });
  }

  static DocumentReference<Base> of(String userId) {
    return FirebaseFirestore.instance.doc('$keyBase/$userId').withConverter<Base>(
        toFirestore: (Base value, SetOptions? options) {
      return <String, Object>{};
    }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
      return Base.fromJson(snapshot.reference);
    });
  }
}

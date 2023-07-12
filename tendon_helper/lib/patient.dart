import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/export.dart';
import 'package:tendon_loader/prescription.dart';
import 'package:tendon_loader/utils.dart';

@immutable
class Patient {
  const Patient({this.patientRef, this.exportRef, this.prescriptionRef});

  factory Patient.fromJson(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? _) {
    final CollectionReference<Export> exportRef = snapshot.reference
        .collection(keyExports)
        .withConverter<Export>(
            fromFirestore: Export.fromJson,
            toFirestore: (Export e, _) => e.toMap());

    final DocumentReference<Prescription> prescriptionRef = snapshot.reference
        .withConverter<Prescription>(
            fromFirestore: Prescription.fromJson,
            toFirestore: (Prescription p, _) => p.toMap());

    return Patient(
      patientRef: snapshot.reference,
      exportRef: exportRef,
      prescriptionRef: prescriptionRef,
    );
  }

  final CollectionReference<Export>? exportRef;
  final DocumentReference<Prescription>? prescriptionRef;
  final DocumentReference<Map<String, dynamic>>? patientRef;
}

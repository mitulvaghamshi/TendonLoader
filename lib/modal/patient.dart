/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import 'package:archive/archive_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/constants.dart';

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
    final DocumentSnapshot<Prescription> _prescription =
        await prescriptionRef!.get();
    List<Export>? _list;
    if (withExports!) {
      final QuerySnapshot<Export> _exports =
          await exportRef!.orderBy(keyTimeStamp, descending: true).get();
      _list = _exports.docs
          .map((QueryDocumentSnapshot<Export> e) => e.data())
          .toList();
    }
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
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/modal/base.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/user.dart';

class AppState {
  String? userId;
  bool? autoUpload;
  double? graphSize;
  bool? fieldEditable;

  DocumentReference<Prescription> userRef(String pUser) =>
      FirebaseFirestore.instance.doc('/$keyBase/$pUser').withConverter<Prescription>(
          fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
        return Prescription.fromMap(snapshot.data()!);
      }, toFirestore: (Prescription value, SetOptions? options) {
        return value.toMap();
      });

  Future<void> getSettings() async {
    final Box<Map<dynamic, dynamic>> _settingsBox = Hive.box(keyAppSettingsBox);
    if (_settingsBox.containsKey(keyAppSettingsBox)) {
      final Map<String, dynamic> _settings = Map<String, dynamic>.from(_settingsBox.get(keyAppSettingsBox)!);
      fieldEditable = _settings['_key_exercise_editable'] as bool? ?? false;
      autoUpload = _settings['_key_auto_upload'] as bool? ?? false;
      graphSize = _settings['_key_graph_size'] as double? ?? 30;
    } else {
      graphSize = 30;
      autoUpload = false;
      fieldEditable = true;
    }
  }

  Future<bool> updateSettings() async {
    await Hive.box<Map<dynamic, dynamic>>(keyAppSettingsBox).put(keyAppSettingsBox, <String, dynamic>{
      '_key_exercise_editable': fieldEditable,
      '_key_auto_upload': autoUpload,
      '_key_graph_size': graphSize,
    });
    return true;
  }

  CollectionReference<Base> get _base => FirebaseFirestore.instance.collection(keyBase).withConverter<Base>(
          toFirestore: (Base value, SetOptions? options) {
        return <String, Object>{};
      }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
        return Base.fromJson(snapshot);
      });

  final List<User> users = <User>[];

  Completer<void> completer = Completer<void>();

  void markDirty() => completer = Completer<void>();

  Future<void> fetchAll() async {
    if (completer.isCompleted) return;
    users.clear();
    final QuerySnapshot<Base> _snapshot = await _base.get();
    final Iterable<Base> _iterable = _snapshot.docs.map((QueryDocumentSnapshot<Base> e) => e.data());
    for (final Base base in _iterable) {
      final QuerySnapshot<Export> _snapshot = await base.export.get();
      final List<Export> _exports = _snapshot.docs.map((QueryDocumentSnapshot<Export> e) => e.data()).toList();
      users.add(User(exports: _exports, reference: base.reference));
    }
    completer.complete();
    return completer.future;
  }

  void remove(DocumentReference<Map<String, dynamic>> reference) {
    final int index = users.indexWhere((User user) => user.id == reference.parent.parent!.id);
    users[index].exports?.removeWhere((Export export) => export.reference == reference);
  }
}

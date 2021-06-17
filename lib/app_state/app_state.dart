import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/app_state/base.dart';
import 'package:tendon_loader/app_state/export.dart';
import 'package:tendon_loader/app_state/user.dart';
import 'package:tendon_loader/constants/constants.dart';
 
class AppState {
  String? userId;

  bool? autoUpload;
  bool? fieldEditable;

  Future<void> getSettings() async {
    final Box<Map<dynamic, dynamic>> _settingsBox = Hive.box(keyAppSettingsBox);
    if (_settingsBox.containsKey(keyAppSettingsBox)) {
      final Map<String, dynamic> _settings = Map<String, dynamic>.from(_settingsBox.get(keyAppSettingsBox)!);
      autoUpload = _settings['_key_auto_upload'] as bool? ?? false;
      fieldEditable = _settings['_key_exercise_editable'] as bool? ?? false;
    } else {
      autoUpload = false;
      fieldEditable = true;
    }
  }

  Future<bool> updateSettings() async {
    await Hive.box<Map<dynamic, dynamic>>(keyAppSettingsBox).put(keyAppSettingsBox, <String, dynamic>{
      '_key_auto_upload': autoUpload,
      '_key_exercise_editable': fieldEditable,
    });
    return true;
  }

  final CollectionReference<Base> _base = FirebaseFirestore.instance.collection(keyBase).withConverter<Base>(
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

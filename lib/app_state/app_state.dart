import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/user.dart';

class AppState {
  double? graphSize;
  bool? autoUpload;
  bool? fieldEditable;

  late int? mvcDuration;
  late Prescription? prescription;

  late final User currentUser;
  final List<User> users = <User>[];

  Future<void> initUser(String id) async {
    currentUser = await User.of(id).fetch();
    prescription = currentUser.prescription;
    mvcDuration = prescription!.mvcDuration;
  }

  Future<void> initAppSettings() async {
    final Box<Map<dynamic, dynamic>> _settingsBox = Hive.box(keyAppSettingsBox);
    if (_settingsBox.containsKey(keyAppSettingsBox)) {
      final Map<String, dynamic> _settings = Map<String, dynamic>.from(_settingsBox.get(keyAppSettingsBox)!);
      graphSize = _settings['_key_graph_size'] as double? ?? 30;
      autoUpload = _settings['_key_auto_upload'] as bool? ?? false;
      fieldEditable = _settings['_key_exercise_editable'] as bool? ?? false;
    } else {
      graphSize = 30;
      autoUpload = false;
      fieldEditable = true;
    }
  }

  Future<bool> updateAppSettings() async {
    await Hive.box<Map<dynamic, dynamic>>(keyAppSettingsBox).put(keyAppSettingsBox, <String, dynamic>{
      '_key_graph_size': graphSize,
      '_key_auto_upload': autoUpload,
      '_key_exercise_editable': fieldEditable,
    });
    return Future<bool>.value(true);
  }

  Completer<void> _complater = Completer<void>();

  void markDirty() => _complater = Completer<void>();

  Future<void> fetchAllData() async {
    if (_complater.isCompleted) return;
    users.clear();
    final QuerySnapshot<User> _snapshot = await User.instance.get();
    final Iterable<User> _iterable = _snapshot.docs.map((QueryDocumentSnapshot<User> u) => u.data());
    for (final User user in _iterable) {
      users.add(await user.fetch());
    }
    _complater.complete();
    return _complater.future;
  }

  void removeExport(DocumentReference<Map<String, dynamic>> reference) {
    final int index = users.indexWhere((User user) => user.id == reference.parent.parent!.id);
    users[index].exports?.removeWhere((Export export) => export.reference == reference);
  }
}

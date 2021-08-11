import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/utils/common.dart';

class AppState {
  Patient? currentUser;
  UserState? userState;
  SettingsState? settingsState;

  final Map<int, Patient> _users = <int, Patient>{};

  Completer<void> _complater = Completer<void>();

  void reload() => _complater = Completer<void>();

  Future<void> fetch() async {
    if (_complater.isCompleted) return;
    final QuerySnapshot<Patient> _snapshot = await dataStore.get();
    for (int i = 0; i < _snapshot.size; i++) {
      _users[i] = await _snapshot.docs[i].data().fetch();
    }
    _complater.complete();
    return _complater.future;
  }

  Future<Map<String, Prescription>> getPrescriptionHistoryOf(int id) async {
    final Map<String, Prescription> _allPrescriptions = <String, Prescription>{};
    for (final Export export in _users[id]!.exports!) {
      if (!export.isMVC) _allPrescriptions[export.dateTime] = export.prescription!;
    }
    return _allPrescriptions;
  }

  Patient getUserWith(int id) => _users[id]!;

  Iterable<int> getUserList() => _users.keys;

  List<int> filter({String? filter}) {
    if (filter == null) return _users.keys.toList();
    final List<int> ids = <int>[];
    for (int i = 0; i < _users.length; i++) {
      if (_users[i]!.id.toLowerCase().contains(filter.toLowerCase())) ids.add(i);
    }
    return ids;
  }
}

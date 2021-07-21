import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/user.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/handlers/splash_handler.dart';

class AppState {
  UserState? userState;
  SettingsState? settingsState;

  int? mvcDuration;
  Prescription? prescription;

  User? currentUser;
  final List<User> users = <User>[];

  Future<void> initAppUser() async {
    //
    isSumulation = false;
    //
    if (userState!.isInBox) {
      await userState!.save();
    } else {
      await boxUserState.put(keyUserStateBoxItem, userState!);
    }
    if (!kIsWeb) {
      if (boxSettingsState.containsKey(userState!.userName.hashCode)) {
        settingsState = boxSettingsState.get(userState!.userName.hashCode);
      } else {
        await boxSettingsState.put(userState!.userName.hashCode, settingsState = SettingsState());
        await _dbRoot.doc(userState!.userName).set(User(prescription: Prescription.empty()));
      }
      currentUser = await User.of(userState!.userName!).fetch();
      togglePrescription();
    }
  }

  void togglePrescription() {
    mvcDuration = prescription = null;
    if (!settingsState!.customPrescriptions!) {
      if (currentUser!.prescription!.targetLoad > 0) {
        prescription = currentUser!.prescription;
      }
      if (currentUser!.prescription!.mvcDuration > 0) {
        mvcDuration = currentUser!.prescription!.mvcDuration;
      }
    }
  }

  CollectionReference<User> get _dbRoot => FirebaseFirestore.instance.collection(keyBase).withConverter<User>(
      toFirestore: (User value, SetOptions? options) => value.toMap(),
      fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) =>
          User.fromJson(snapshot.reference));

  Completer<void> _complater = Completer<void>();

  void get reload => _complater = Completer<void>();

  Future<void> fetch() async {
    if (_complater.isCompleted) return;
    final QuerySnapshot<User> _snapshot = await _dbRoot.get();
    final Iterable<User> _iterable = _snapshot.docs.map((QueryDocumentSnapshot<User> u) => u.data());
    if (_iterable.isNotEmpty) {
      users.clear();
      for (final User user in _iterable) {
        users.add(await user.fetch());
      }
    }
    _complater.complete();
    return _complater.future;
  }

  void removeExportBy(DocumentReference<Map<String, dynamic>> reference) {
    final int index = users.indexWhere((User user) => user.id == reference.parent.parent!.id);
    users[index].exports?.removeWhere((Export export) => export.reference == reference);
  }
}

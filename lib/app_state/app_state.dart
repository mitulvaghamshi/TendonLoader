import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader/login/initializer.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/user.dart';
import 'package:tendon_loader/modal/user_state.dart';

class AppState {
  UserState? userState;
  SettingsState? settingsState;

  int? mvcDuration;
  Prescription? prescription;

  User? currentUser;
  final List<User> users = <User>[];

  Future<void> initAppUser() async {
    //
    simulateBT = false;
    //
    if (userState!.isInBox) {
      await userState!.save();
    } else {
      await boxUserState.put('box_user_state_item', userState!);
    }
    if (!kIsWeb) {
      if (boxSettingsState.containsKey(userState!.userName.hashCode)) {
        settingsState = boxSettingsState.get(userState!.userName.hashCode);
      } else {
        await boxSettingsState.put(userState!.userName.hashCode, settingsState = SettingsState());
        await _instance.doc(userState!.userName).set(User(prescription: Prescription.empty()));
      }
      currentUser = await User.of(userState!.userName!).fetch();
      togglePrescription();
    }
  }

  void togglePrescription() {
    if (settingsState!.customPrescriptions!) {
      mvcDuration = null;
      prescription = null;
    } else {
      if (currentUser!.prescription!.targetLoad > 0) {
        prescription = currentUser!.prescription;
      }
      if (currentUser!.prescription!.mvcDuration > 0) {
        mvcDuration = currentUser!.prescription!.mvcDuration;
      }
    }
  }

  CollectionReference<User> get _instance {
    return FirebaseFirestore.instance.collection(keyBase).withConverter<User>(
        toFirestore: (User value, SetOptions? options) {
      return value.toMap();
    }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
      return User.fromJson(snapshot.reference);
    });
  }

  Completer<void> _complater = Completer<void>();

  void markDirty() => _complater = Completer<void>();

  Future<void> fetchAllData() async {
    if (_complater.isCompleted) return;
    users.clear();
    final QuerySnapshot<User> _snapshot = await _instance.get();
    final Iterable<User> _iterable = _snapshot.docs.map((QueryDocumentSnapshot<User> u) => u.data());
    for (final User user in _iterable) {
      users.add(await user.fetch());
    }
    _complater.complete();
    return _complater.future;
  }

  void removeExportBy(DocumentReference<Map<String, dynamic>> reference) {
    final int index = users.indexWhere((User user) => user.id == reference.parent.parent!.id);
    users[index].exports?.removeWhere((Export export) => export.reference == reference);
  }
}

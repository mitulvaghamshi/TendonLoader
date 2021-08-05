import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/user.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/utils/constants.dart';

class AppState {
  User? currentUser;
  UserState? userState;
  SettingsState? settingsState;
  final List<User> users = <User>[];

  Completer<void> _complater = Completer<void>();

  void reload() => _complater = Completer<void>();

  Future<void> fetch() async {
    if (_complater.isCompleted) return;
    final QuerySnapshot<User> _snapshot = await dbRoot.get();
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
}

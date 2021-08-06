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

  final Map<int, User> _users = <int, User>{};

  Completer<void> _complater = Completer<void>();
  void reload() => _complater = Completer<void>();

  Future<void> fetch() async {
    if (_complater.isCompleted) return;
    final QuerySnapshot<User> _snapshot = await dbRoot.get();
    for (int i = 0; i < _snapshot.size; i++) {
      _users[i] = await _snapshot.docs[i].data().fetch();
    }
    _complater.complete();
    return _complater.future;
  }

  User getUserById(int id) => _users[id]!;

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

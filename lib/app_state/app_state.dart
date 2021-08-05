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

  final Map<String, User> _users = <String, User>{};

  Completer<void> _complater = Completer<void>();
  void reload() => _complater = Completer<void>();

  Future<void> fetch() async {
    if (_complater.isCompleted) return;
    final QuerySnapshot<User> _snapshot = await dbRoot.get();
    final Iterable<User> _iterable = _snapshot.docs.map((QueryDocumentSnapshot<User> u) => u.data());
    if (_iterable.isNotEmpty) {
      _users.clear();
      for (final User user in _iterable) {
        _users[user.id] = await user.fetch();
      }
    }
    _complater.complete();
    return _complater.future;
  }

  User getUserById(String id) => _users[id]!;

  Iterable<String> getUserList() => _users.keys;

  List<String> filter({String? filter}) {
    if (filter == null) return _users.keys.toList();
    final List<String> ids = <String>[];
    for (final User user in _users.values) {
      if (user.id.toLowerCase().contains(filter.toLowerCase())) {
        ids.add(user.id);
      }
    }
    return ids;
  }
}

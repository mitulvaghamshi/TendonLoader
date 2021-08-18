import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/utils/common.dart';

@immutable
class AppStateWidget extends StatefulWidget {
  const AppStateWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  AppStateWidgetState createState() => AppStateWidgetState();
}

class AppStateWidgetState extends State<AppStateWidget> {
  final AppState _data = AppState();

  Completer<void> _complater = Completer<void>();

  void refresh() => setState(() {});

  void setRefetch() => _complater = Completer<void>();

  Future<void> fetch() async {
    if (_complater.isCompleted) return;
    final QuerySnapshot<Patient> _snapshot = await dataStore.get();
    if (_snapshot.size > 0) _data.users.clear();
    for (int i = 0; i < _snapshot.size; i++) {
      _data.users[i] = await _snapshot.docs[i].data().fetch();
    }
    _complater.complete();
    return _complater.future;
  }

  Iterable<int> get userList => _data.users.keys;

  Patient getUserBy(int id) => _data.users[id]!;

  Iterable<int> filter({String? filter}) {
    if (filter == null) return userList;
    final List<int> _ids = <int>[];
    for (final MapEntry<int, Patient> user in _data.users.entries) {
      if (user.value.id.toLowerCase().contains(filter.toLowerCase())) {
        _ids.add(user.key);
      }
    }
    return _ids;
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(data: _data, child: widget.child);
  }
}

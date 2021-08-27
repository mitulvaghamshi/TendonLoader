import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/utils/common.dart';

@immutable
class AppStateWidget extends StatefulWidget {
  const AppStateWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static AppStateWidgetState of(BuildContext context) {
    return context.findAncestorStateOfType<AppStateWidgetState>()!;
  }

  @override
  AppStateWidgetState createState() => AppStateWidgetState();
}

class AppStateWidgetState extends State<AppStateWidget> {
  final AppState _data = AppState();

  Completer<void> _complater = Completer<void>();

  void setRefetch() => _complater = Completer<void>();

  Patient getUser(int id) => _data.users[id]!;

  Future<void> fetch() async {
    if (_complater.isCompleted) return;
    final QuerySnapshot<Patient> _snapshot = await dbRoot.get();
    if (_snapshot.size > 0) _data.users.clear();
    for (int i = 0; i < _snapshot.size; i++) {
      _data.users[i] = await _snapshot.docs[i].data().fetch(withExports: true);
    }
    _complater.complete();
    return _complater.future;
  }

  Iterable<int> filterUsers(String? filter) {
    userClick.value = null;
    exportClick.value = null;
    if (filter == null) {
      // setState(() => _data.userList = _data.users.keys);
      return _data.users.keys;
    } else {
      final List<int> _filtered = <int>[];
      for (final MapEntry<int, Patient> user in _data.users.entries) {
        if (user.value.id.toLowerCase().contains(filter.toLowerCase())) {
          _filtered.add(user.key);
        }
      }
      // setState(() => _data.userList = _filtered);
      return _filtered;
    }
  }

  Iterable<Export>? filterExports(String? filter) {
    exportClick.value = null;
    final Iterable<Export>? _exports = _data.users[userClick.value]?.exports;
    if (filter == null) {
      // setState(() => _data.exportList = _exports);
      return _exports;
    } else {
      final Iterable<Export>? _filtered = _exports?.where((Export export) {
        return export.fileName.toLowerCase().contains(filter.toLowerCase());
      });
      // setState(() => _data.exportList = _filtered);
      return _filtered;
    }
  }

  void removeExport(Export export) {}

  @override
  Widget build(BuildContext context) {
    return AppStateScope(data: _data, child: widget.child);
  }
}

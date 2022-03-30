import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/models/export.dart';
import 'package:tendon_loader/shared/models/patient.dart';
import 'package:tendon_loader/shared/utils/common.dart';
import 'package:tendon_loader/web/common.dart';
import 'package:tendon_loader/web/states/app_state_scope.dart';

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

  Iterable<int> get userList => _data.users.keys;
  Iterable<Export>? get exportList => _data.users[userNotifier.value]?.exports;

  Completer<void> _complater = Completer<void>();

  void setRefetch() => _complater = Completer<void>();

  Patient getUser(int id) => _data.users[id]!;

  Future<void> fetch() async {
    if (_complater.isCompleted) return;
    final QuerySnapshot<Patient> _snapshot = await dbRoot.get();
    if (_snapshot.size > 0) {
      _data.users.clear();
      userNotifier.value = null;
      exportNotifier.value = null;
    }
    for (int i = 0; i < _snapshot.size; i++) {
      _data.users[i] = await _snapshot.docs[i].data().fetch(withExports: true);
    }
    _complater.complete();
    return _complater.future;
  }

  Iterable<int> filterUsers(String? filter) {
    userNotifier.value = null;
    exportNotifier.value = null;
    if (filter == null) {
      return _data.users.keys;
    } else {
      final List<int> _filtered = <int>[];
      for (final MapEntry<int, Patient> user in _data.users.entries) {
        if (user.value.id.toLowerCase().contains(filter.toLowerCase())) {
          _filtered.add(user.key);
        }
      }
      return _filtered;
    }
  }

  Iterable<Export>? filterExports(String? filter) {
    exportNotifier.value = null;
    final Iterable<Export>? _exports = _data.users[userNotifier.value]?.exports;
    if (filter == null) {
      return _exports;
    } else {
      final Iterable<Export>? _filtered = _exports?.where((Export export) {
        return export.fileName.toLowerCase().contains(filter.toLowerCase());
      });
      return _filtered;
    }
  }

  Future<void> removeExport(Export export) async {
    final int _id = userNotifier.value!;
    final Patient _user = getUser(_id);
    _user.exports!.remove(export);
    setState(() => _data.users[_id] = _user);
    exportNotifier.value = null;
    await export.reference!.delete();
  }

  Future<void> removeAllExports(int id) async {
    final Patient _user = getUser(id);
    _user.exports!.clear();
    setState(() => _data.users[id] = _user);
    exportNotifier.value = null;
    userNotifier.value = null;
    await _user.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(data: _data, child: widget.child);
  }
}

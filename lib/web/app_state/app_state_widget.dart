/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/web/app_state/app_state.dart';
import 'package:tendon_loader/web/app_state/app_state_scope.dart';
import 'package:tendon_loader/web/common.dart';

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

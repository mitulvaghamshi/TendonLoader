import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';

class AppStateWidgetState extends State<AppStateWidget> {
  final AppState _data = AppState();

  @override
  Widget build(BuildContext context) {
    return AppStateScope(data: _data, child: widget.child);
  }

  void refresh() => setState(() {});
}

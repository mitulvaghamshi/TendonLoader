import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';

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

  @override
  Widget build(BuildContext context) {
    return AppStateScope(data: _data, child: widget.child);
  }

  void refresh() => setState(() {});
}

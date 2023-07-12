import 'package:flutter/material.dart';
import 'package:tendon_loader/app.dart';
import 'package:tendon_loader/network/api.dart';
import 'package:tendon_loader/network/app_state.dart';

void main() {
  final api = Api.empty();
  final state = AppState(api: api);

  runApp(MainApp(state: state));
}

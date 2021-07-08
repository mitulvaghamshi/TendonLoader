import 'dart:typed_data' show Endian, Uint8List;

import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';

extension ExTimer on int {
  String get toTime => this == 0 ? 'GO!' : '${this ~/ 60}:${(this % 60).toString().padLeft(2, '0')}';
}

extension ExTimeFormat on double {
  String get toTime => '🕒 ${this ~/ 60}:${(this % 60).toStringAsFixed(0).padLeft(2, '0')} Sec';
}

extension ExCell on String {
  DataCell get toCell => DataCell(Center(child: Text(this)));
  DataCell get toBigCell => DataCell(Text(this, style: const TextStyle(fontSize: 16)));
}

extension ExConvert on List<int> {
  double get toWeight => double.parse(
      (Uint8List.fromList(this).buffer.asByteData().getFloat32(0, Endian.little).abs()).toStringAsFixed(1));

  double get toTime => double.parse(
      (Uint8List.fromList(this).buffer.asByteData().getUint32(0, Endian.little) / 1000000.0).toStringAsFixed(1));
}

extension ExAppState on BuildContext {
  AppState get model => dependOnInheritedWidgetOfExactType<AppStateScope>()!.data;
  AppStateWidgetState get view => findAncestorStateOfType<AppStateWidgetState>()!;
}

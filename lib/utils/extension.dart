import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';

extension ExTimeer on int {
  String get toSec => this < 100 ? 'GO!' : (this / 1000).truncate().toString();
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

  void showSnackBar(Widget content) => ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: content));

  void pop<T extends Object?>([T? result]) => Navigator.pop<T>(this, result);

  Future<T?> push<T extends Object?>(String routeName, {bool? replace = false, Object? arguments}) {
    return replace!
        ? Navigator.pushReplacementNamed<T, T>(this, routeName, arguments: arguments)
        : Navigator.pushNamed<T>(this, routeName, arguments: arguments);
  }
}

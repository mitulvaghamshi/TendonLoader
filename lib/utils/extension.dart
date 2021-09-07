/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/login.dart';
import 'package:tendon_loader/utils/routes.dart';

extension ExString on String {
  DataCell get toCell {
    return DataCell(Text(this, style: const TextStyle(fontSize: 16)));
  }
}

extension ExContext on BuildContext {
  void showSnackBar(Widget content) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: content));
  }

  void pop<T extends Object?>([T? result]) => Navigator.pop<T>(this, result);

  Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) =>
      Navigator.push<T>(this, buildRoute<T>(routeName));

  Future<T?> replace<T extends Object?>(String routeName) =>
      Navigator.pushReplacement<T, T>(this, buildRoute<T>(routeName));

  Future<void> logout() => Navigator.pushAndRemoveUntil<void>(
      this, buildRoute(Login.route), (_) => false);

  Future<T?> popup<T extends Object?>(
    String routeName, {
    bool? isFullScreen = true,
    Object? arguments,
  }) {
    return Navigator.push<T>(this, buildRoute<T>(routeName, isFullScreen));
  }
}

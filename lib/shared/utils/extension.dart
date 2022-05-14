import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/login_screen.dart';
import 'package:tendon_loader/shared/utils/routes.dart';

/// String to DataTable cell. This extension method on [String] object
/// will return a [DataCell] containig a Text widget with this string
/// as a text value, used by the [DataTable] widgets.
extension ExString on String {
  DataCell get toCell =>
      DataCell(Text(this, style: const TextStyle(fontSize: 16)));
}

/// Create navigator methods. Extension methods on the [BuildContext] class
/// shorten the long navigator methods with named route.
extension ExContext on BuildContext {
  /// Display a [SnackBar] with given widget content.
  void showSnackBar(Widget content) =>
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: content));

  /// Pop with returned result.
  void pop<T extends Object?>([T? result]) => Navigator.pop<T>(this, result);

  /// Push with arguments and returned result type.
  Future<T?> push<T extends Object?>(String route, {Object? args}) =>
      Navigator.push<T>(this, buildRoute<T>(route));

  /// Push removing all the previous route history. Clear route history!
  Future<void> logout() => Navigator.pushAndRemoveUntil<void>(
      this, buildRoute(LoginScreen.route), (_) => false);
}

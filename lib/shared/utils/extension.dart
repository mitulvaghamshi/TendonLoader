import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/login_screen.dart';
import 'package:tendon_loader/shared/utils/routes.dart';

/// String to DataTable cell.
///
/// This extension method on [String] object will return
/// a [DataCell] containig a Text widget with this string as value,
/// used by the [DataTable] widgets.
extension ExString on String {
  DataCell get toCell {
    return DataCell(Text(this, style: const TextStyle(fontSize: 16)));
  }
}

/// Create convenient navigator methods.
///
/// Extension methods on this [BuildContext] class will
/// help reduce long navigator methods with named route.
extension ExContext on BuildContext {
  /// Display a [SnackBar],
  /// Can be customized to create identical look throughout the app.
  void showSnackBar(Widget content) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: content));
  }

  /// [Navigator.pop] with returned result.
  void pop<T extends Object?>([T? result]) => Navigator.pop<T>(this, result);

  /// [Navigator.push] with arguments and returned result type.
  /// Allow back navigation.
  Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) =>
      Navigator.push<T>(this, buildRoute<T>(routeName));

  /// [Navigator.push] removing immidiate one level back history.
  Future<T?> replace<T extends Object?>(String routeName) =>
      Navigator.pushReplacement<T, T>(this, buildRoute<T>(routeName));

  /// [Navigator.push] removing all the previous route history.
  Future<void> logout() => Navigator.pushAndRemoveUntil<void>(
      this, buildRoute(LoginScreen.route), (_) => false);

  /// Display any screen as a dialog, useful in web layout.
  Future<T?> popup<T extends Object?>(
    String routeName, {
    bool? isFullScreen = true,
    Object? arguments,
  }) {
    return Navigator.push<T>(this, buildRoute<T>(routeName, isFullScreen));
  }
}

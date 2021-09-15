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

import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/login.dart';
import 'package:tendon_loader/utils/routes.dart';

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
      this, buildRoute(Login.route), (_) => false);

  /// Display any screen as a dialog, useful in web layout.
  Future<T?> popup<T extends Object?>(
    String routeName, {
    bool? isFullScreen = true,
    Object? arguments,
  }) {
    return Navigator.push<T>(this, buildRoute<T>(routeName, isFullScreen));
  }
}

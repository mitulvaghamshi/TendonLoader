import 'package:flutter/material.dart';

/// An empty defination of [AnchorElement] class from [dart:html] library.
/// Analyzer warns for using web libraries [dart:html] in flutter app,
/// the [AnchorElement] used in Web app to download generated excel file.
/// Web build uses class from [dart:html] lib, while mobile builds uses this
/// empty class.
@immutable
class AnchorElement {
  const AnchorElement({this.href});

  // Link with excel data embaded, on click triggers download on browsers.
  final String? href;

  void click() {
    // TODO(mitul): implement platform specific code to
    // allow download on mobile and desktop devices.
  }

  /// @param attr - a download attribute on web links.
  /// @param value - name of the file.
  void setAttribute(String attr, String value) {
    // TODO(mitul): Create and prepare a File to download
    // on mobile or desktop device. May require platform specific
    // implementation for different devices/OSs.
  }
}

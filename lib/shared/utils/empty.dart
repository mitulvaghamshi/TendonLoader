import 'package:flutter/material.dart';

/// A mock AnchorElement class of [dart:html] library.
///
/// Analyzer warns for using web libraries [dart:html] in flutter app,
/// The [AnchorElement] used (only) in Web portal to download an exported data.
/// Web build uses [dart:html] while mobile builds
/// uses this class which does nothing.
///
/// This class can be provided with a functionality allowing
/// mobile (or desktop) app to download export files on local storage.
@immutable
class AnchorElement {
  const AnchorElement({this.href});
  final String? href;
  void click() {
    /// Can download and open it using
    /// any supported application (like MS-Office).
  }
  void setAttribute(String attr, String value) {
    /// May create a file using platform specific implementation.
    /// All platforms require their own implementation.
    /// A plugin can be created for this purpose.
  }
}

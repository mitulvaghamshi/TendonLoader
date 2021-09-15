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

/// A mock [AnchoElement] class of [dart:html] library.
///
/// Analyzer warns for using web libraries [dart:html] in flutter app,
/// The [AnchorElement] used (only) in Web portal to download a exported data.
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
    /// any supported aplication (like MS-Office).
  }
  void setAttribute(String attr, String value) {
    /// May create a file using platform spacific implementation.
    /// All platforms require their own implementation.
    /// A plugin can be created for this perpose. 
  }
}

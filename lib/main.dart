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
import 'package:tendon_loader/app.dart';
import 'package:tendon_loader/utils/common.dart';

/// The entry point of the application for both the mobile only 
/// while, web provided with it's own main method. see [lib/web/main.dart].
///
/// The method is marked as [async] to perform basic but mandatory initialization,
/// by calling the top level [initApp] method which is responsible 
/// for the proper initialization of require componets including: [Firebase], [Hive].
///
/// [awaited] initialization causes slight [delay] in app [startup], but makes 
/// rest of the app life-cycle smoother and convenient.
/// 
/// Even if the prior initialization requirement, 
/// this app does not include any [splash screen] and navigate user to [login screen]
/// as soon as setup is complate. see [lib/utils/common/initApp()] method for more detail.
///
/// [NULL SAFETY IS HERE!!!]
/// [App] and all [dependencies] are fully [supported] with [null-safety] feature.
Future<void> main() async {
  await initApp(); // init must be done before starting the app.
  runApp(const TendonLoader()); // wait for system to complate init steps.
}

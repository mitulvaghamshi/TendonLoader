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

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/routes.dart';
import 'package:tendon_loader/utils/themes.dart';

/// The first and main widget in the application's widget tree to the entire app structure,
/// disposing this widget causes the application exit.
///
/// The application is mainly designed using Material-Design-Guideline, 
/// but also allows app to adapt some iOS styles such as text, color, icons, etc.
/// rather forcing app to use Android (Material) styles.
/// 
/// The app provided with two themes [Light] and [Dark] varients with custom colors
/// and shapes for basic components like list-items and buttons.
/// see [lib/utils/themes.dart] for the implementation.
///
/// The app uses route table and custom route-builder to navigate back and forth 
/// between different screens.
/// implementation at [lib/utils/routes.dart]
///
/// App is constructed using combination of material and cupertino design systems.
///
/// App is initially (first-launch) started with [Light] theme and allow user to toggle
/// with [Dark] varient using app settings see [lib/screens/app_settings.dart].
/// The choice of the selected theme is stored in hive-db (a file based storage system),
/// app is highly depended on [Hive] for storing different user generated data and settings.
/// 
/// The app forces user to choose either theme manually and not depend on system defaults
/// this will prevent app to be restarted by the system when it changes it's default theme,
/// i.e. a system will automatically switch to [Dark Mode] at night 
/// and back to [Light Mode] in the morning, this will causes problem when 
/// any session is running as [MVC Test] or [Exercise Mode].
class TendonLoader extends StatelessWidget {
  const TendonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _isDark = boxDarkMode.get(
      keyDarkModeBox,
      defaultValue: false,
    )!;
    return MaterialApp(
      routes: routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      title: 'Tendon Loader',
      initialRoute: Navigator.defaultRouteName,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      builder: (_, Widget? child) => CupertinoTheme(
        data: const CupertinoThemeData(),
        child: Material(child: child),
      ),
    );
  }
}

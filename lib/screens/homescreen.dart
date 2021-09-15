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

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/bluetooth/device_handler.dart';
import 'package:tendon_loader/bluetooth/lists/connected_list.dart';
import 'package:tendon_loader/custom/app_frame.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/custom/custom_tile.dart';
import 'package:tendon_loader/custom/progress_tile.dart';
import 'package:tendon_loader/screens/app_settings.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/screens/graph/graph_handler.dart';
import 'package:tendon_loader/screens/livedata/live_data.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/screens/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/routes.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:wakelock/wakelock.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String name = 'Tendon Loader';
  static const String route = '/homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    Future<void>.delayed(const Duration(seconds: 1), () async {
      await tryUpload(context);
    });
  }

  Future<void> _cleanup() async {
    await disconnectDevice();
    await Wakelock.disable();
    await disposePlayer();
    await signOut();
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  Future<bool?> _onExit() async {
    return CustomDialog.show<bool>(
      context,
      title: 'Just a moment...',
      content: FutureBuilder<void>(
        future: _cleanup(),
        builder: (_, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            context.pop(true);
          }
          return const CustomProgress();
        },
      ),
    );
  }

  Future<void> _connectProgressor() async {
    await CustomDialog.show<void>(
      context,
      title: 'Connect Progressor',
      content: const ConnectedList(),
    ).then((_) async {
      await stopWeightMeas().then((_) => GraphHandler.clear());
    });
  }

  Future<void> _startAutoExercise() async {
    return CustomDialog.show<void>(
      context,
      title: 'Start Exercise',
      content: FittedBox(child: Builder(builder: (BuildContext context) {
        return settingsState.prescription!.toTable();
      })),
      action: CustomButton(
        left: const Text('Go', style: TextStyle(color: colorMidGreen)),
        right: const Icon(Icons.arrow_forward, color: colorMidGreen),
        onPressed: () async => context.replace(ExerciseMode.route),
      ),
    );
  }

  void _navigateTo(String route) {
    if (progressor == null) {
      _connectProgressor();
    } else {
      final bool _isCustom = settingsState.customPrescriptions!;
      switch (route) {
        case LiveData.route:
          context.push(LiveData.route);
          break;
        case MVCTesting.route:
          if (_isCustom) {
            context.push(NewMVCTest.route);
          } else if (settingsState.mvcDuration != null) {
            context.push(MVCTesting.route);
          } else {
            context.showSnackBar(const Text(descNoMvcAvailable));
          }
          break;
        case ExerciseMode.route:
          if (_isCustom) {
            context.push(NewExercise.route);
          } else if (settingsState.prescription != null) {
            _startAutoExercise();
          } else {
            context.showSnackBar(const Text(descNoExerciseAvailable));
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(HomeScreen.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async => context.push(AppSettings.route),
          ),
        ],
      ),
      floatingActionButton: CustomButton(
        onPressed: _connectProgressor,
        left: const Icon(Icons.bluetooth),
        right: const Text('Connect Device'),
      ),
      body: SingleChildScrollView(
        child: AppFrame(
          onExit: () async => await _onExit() ?? false,
          child: Column(children: <Widget>[
            const CustomImage(),
            CustomTile(
              title: LiveData.name,
              left: const Icon(Icons.show_chart, color: colorIconBlue),
              right: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _navigateTo(LiveData.route),
            ),
            CustomTile(
              title: MVCTesting.name,
              left: const Icon(Icons.airline_seat_legroom_extra,
                  color: colorIconBlue),
              right: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _navigateTo(MVCTesting.route),
            ),
            CustomTile(
              title: ExerciseMode.name,
              left: const Icon(Icons.directions_run, color: colorIconBlue),
              right: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _navigateTo(ExerciseMode.route),
            ),
          ]),
        ),
      ),
    );
  }
}

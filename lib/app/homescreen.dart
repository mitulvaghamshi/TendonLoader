import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tendon_loader/app/bluetooth/bluetooth_handler.dart';
import 'package:tendon_loader/app/bluetooth/connected_list.dart';
import 'package:tendon_loader/app/bluetooth/simulator.dart';
import 'package:tendon_loader/app/exercise/exercise_mode.dart';
import 'package:tendon_loader/app/exercise/new_exercise.dart';
import 'package:tendon_loader/app/graph/graph_handler.dart';
import 'package:tendon_loader/app/livedata/live_data.dart';
import 'package:tendon_loader/app/mvctest/mvc_testing.dart';
import 'package:tendon_loader/app/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/app/widgets/custom_tile.dart';
import 'package:tendon_loader/shared/settings_screen.dart';
import 'package:tendon_loader/shared/utils/common.dart';
import 'package:tendon_loader/shared/utils/constants.dart';
import 'package:tendon_loader/shared/utils/extension.dart';
import 'package:tendon_loader/shared/utils/routes.dart';
import 'package:tendon_loader/shared/widgets/alert_widget.dart';
import 'package:tendon_loader/shared/widgets/app_logo.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';
import 'package:tendon_loader/shared/widgets/frame_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String route = '/homescreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 1), () async {
      await tryUpload(context);
    });
  }

  Future<void> _cleanup() async {
    await disconnectDevice();
    await signOut();
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  Future<bool?> _onExit() async {
    return AlertWidget.show<bool>(
      context,
      title: 'Just a moment...',
      content: FutureBuilder<void>(
        future: _cleanup(),
        builder: (_, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            context.pop(true);
          }
          return const CustomTile(
            title: 'Please wait...',
            left: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }

  Future<void> _connectProgressor() async {
    await AlertWidget.show<void>(
      context,
      title: 'Connect Progressor',
      content: const ConnectedList(),
    ).then((_) async {
      await stopWeightMeas().then((_) => GraphHandler.clear());
    });
  }

  Future<void> _startAutoExercise() async {
    return AlertWidget.show<void>(
      context,
      title: 'Start Exercise',
      content: FittedBox(child: Builder(builder: (BuildContext context) {
        return settingsState.prescription!.toTable();
      })),
      action: ButtonWidget(
        left: const Text('Go', style: TextStyle(color: Color(0xff3ddc85))),
        right: const Icon(Icons.arrow_forward, color: Color(0xff3ddc85)),
        onPressed: () async => context.replace(ExerciseMode.route),
      ),
    );
  }

  Future<void> _navigateTo(String route) async {
    if (!isSumulation && progressor == null) {
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
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Tendon Loader'),
        actions: <Widget>[
          ButtonWidget(
            left: const Icon(Icons.settings),
            onPressed: () async => context.push(SettingsScreen.route),
          ),
        ],
      ),
      floatingActionButton: ButtonWidget(
        onPressed: _connectProgressor,
        left: const Icon(Icons.bluetooth),
        right: const Text('Connect Device'),
      ),
      body: SingleChildScrollView(
        child: FrameWidget(
          onExit: () async => await _onExit() ?? false,
          child: Column(children: <Widget>[
            const AppLogo(),
            CustomTile(
              title: LiveData.name,
              left: const Icon(Icons.show_chart),
              right: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _navigateTo(LiveData.route),
            ),
            CustomTile(
              title: MVCTesting.name,
              left: const Icon(Icons.airline_seat_legroom_extra),
              right: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _navigateTo(MVCTesting.route),
            ),
            CustomTile(
              title: ExerciseMode.name,
              left: const Icon(Icons.directions_run),
              right: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _navigateTo(ExerciseMode.route),
            ),
          ]),
        ),
      ),
    );
  }
}

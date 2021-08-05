import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/custom/custom_tile.dart';
import 'package:tendon_loader/handlers/audio_handler.dart';
import 'package:tendon_loader/handlers/auth_handler.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/screens/device/lists/connected_list.dart';
import 'package:tendon_loader/screens/exercise/auto_exercise.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/screens/livedata/live_data.dart';
import 'package:tendon_loader/screens/login/splash.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/screens/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/screens/settings/user_settings.dart';
import 'package:tendon_loader/utils/descriptions.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:wakelock/wakelock.dart';

enum _RouteType { liveData, mvcTest, exerciseMode }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String route = '/homeScreen';
  static const String name = 'Tendon Loader';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    Future<void>.delayed(const Duration(seconds: 1), () => tryUpload(context));
  }

  Future<void> _cleanup() async {
    await Wakelock.disable();
    await disconnectDevice();
    await firebaseLogout();
    await disposePlayer();
    return Future<void>.delayed(const Duration(microseconds: 800));
  }

  Future<bool?> _onExit(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (_) => CustomDialog(
        content: FutureBuilder<void>(
          future: _cleanup(),
          builder: (_, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) context.pop(true);
            return const CustomProgress();
          },
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, [_RouteType? type]) {
    if (type == null || progressor == null && !isSumulation) {
      _connectProgressor(context);
    } else {
      final bool isCustom = context.model.settingsState!.customPrescriptions!;
      if (type == _RouteType.liveData) {
        context.push(LiveData.route);
      } else if (type == _RouteType.mvcTest) {
        if (isCustom) {
          context.push(NewMVCTest.route);
        } else if (context.model.settingsState!.mvcDuration != null) {
          context.push(MVCTesting.route);
        } else {
          context.showSnackBar(const Text(descNoMvcAvailable));
        }
      } else if (type == _RouteType.exerciseMode) {
        if (isCustom) {
          context.push(NewExercise.route);
        } else if (context.model.settingsState!.prescription != null) {
          _startAutoExercise(context);
        } else {
          context.showSnackBar(const Text(descNoExerciseAvailable));
        }
      }
    }
  }

  Future<void> _connectProgressor(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CustomDialog(title: 'Connect Progressor', content: ConnectedList()),
    ).then((_) async => stopWeightMeas());
  }

  Future<void> _startAutoExercise(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => CustomDialog(
        title: 'Start Exercise',
        content: const FittedBox(child: AutoExercise()),
        action: CustomButton(
          left: const Text('Go', style: TextStyle(color: colorGoogleGreen)),
          right: const Icon(Icons.arrow_forward_rounded, color: colorGoogleGreen),
          onPressed: () async => context.push(ExerciseMode.route, replace: true),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text(HomeScreen.name), actions: <Widget>[
        IconButton(icon: const Icon(Icons.settings), onPressed: () async => context.push(UserSettings.route)),
      ]),
      floatingActionButton: CustomButton(
        onPressed: () => _navigateTo(context),
        left: const Icon(Icons.bluetooth_rounded),
        right: const Text('Connect Device'),
      ),
      body: SingleChildScrollView(
        child: AppFrame(
          onExit: () async => await _onExit(context) ?? false,
          child: Column(children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: CustomImage()),
            CustomTile(
              title: LiveData.name,
              left: const Icon(Icons.show_chart, color: colorBlue),
              right: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _navigateTo(context, _RouteType.liveData),
            ),
            CustomTile(
              title: MVCTesting.name,
              left: const Icon(Icons.airline_seat_legroom_extra, color: colorBlue),
              right: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _navigateTo(context, _RouteType.mvcTest),
            ),
            CustomTile(
              title: ExerciseMode.name,
              left: const Icon(Icons.directions_run, color: colorBlue),
              right: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _navigateTo(context, _RouteType.exerciseMode),
            ),
          ]),
        ),
      ),
    );
  }
}

Future<bool?> tryUpload(BuildContext context) async {
  if (boxExport.isEmpty) return false;
  if ((await Connectivity().checkConnectivity()) != ConnectivityResult.none) {
    int count = 0;
    for (final Export export in boxExport.values) {
      if (await export.upload(context)) count++;
    }
    await showDialog<void>(
      context: context,
      builder: (_) => CustomDialog(
        title: 'Upload success!!!',
        content: Text('$count file(s) submitted successfully!', textAlign: TextAlign.center, style: tsG24B),
      ),
    );
  }
}

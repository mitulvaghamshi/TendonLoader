import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_tile.dart';
import 'package:tendon_loader/handlers/splash_handler.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/screens/livedata/live_data.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/screens/settings/user_settings.dart';
import 'package:tendon_loader/utils/enums.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/helper.dart';
import 'package:wakelock/wakelock.dart';

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
    if (boxExport.isNotEmpty) {
      Future<void>.delayed(const Duration(seconds: 1), () => tryUpload(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text(HomeScreen.name), actions: <Widget>[
        IconButton(icon: const Icon(Icons.settings), onPressed: () async => context.push(UserSettings.route)),
      ]),
      floatingActionButton: CustomButton(
        onPressed: () => navigateTo(context),
        icon: const Icon(Icons.bluetooth_rounded),
        child: const Text('Connect Device'),
      ),
      body: SingleChildScrollView(
        child: AppFrame(
          onExit: () async => await onExit(context) ?? false,
          child: Column(children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: AppLogo()),
            CustomTile(
              name: LiveData.name,
              icon: Icons.show_chart_rounded,
              onTap: () => navigateTo(context, RouteType.liveData),
            ),
            CustomTile(
              name: MVCTesting.name,
              icon: Icons.airline_seat_legroom_extra,
              onTap: () => navigateTo(context, RouteType.mvcTest),
            ),
            CustomTile(
              name: ExerciseMode.name,
              icon: Icons.directions_run_rounded,
              onTap: () => navigateTo(context, RouteType.exerciseMode),
            ),
          ]),
        ),
      ),
    );
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/router/router.dart';
import 'package:tendon_loader/common/widgets/app_logo.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/screens/bluetooth/models/bluetooth_handler.dart';
import 'package:tendon_loader/screens/bluetooth/models/simulator.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/screens/livedata/live_data.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';

@immutable
final class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

final class HomeScreenState extends State<HomeScreen> with Progressor {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tendon Loader')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: WillPopScope(
          onWillPop: () async => disconnect().then((_) => true),
          child: Column(children: [
            const Hero(tag: 'hero-app-logo', child: AppLogo.sized()),
            const SizedBox(height: 30),
            RawButton.extended(
              color: Colors.orange,
              onTap: () => _navigateTo(LiveData.name),
              child: const Text(LiveData.name, style: Styles.boldWhite),
            ),
            const SizedBox(height: 8),
            RawButton.extended(
              color: Colors.orange,
              onTap: () => _navigateTo(MVCTesting.name),
              child: const Text(MVCTesting.name, style: Styles.boldWhite),
            ),
            const SizedBox(height: 8),
            RawButton.extended(
              color: Colors.orange,
              onTap: () => _navigateTo(ExerciseMode.name),
              child: const Text(ExerciseMode.name, style: Styles.boldWhite),
            ),
            const SizedBox(height: 8),
            Hero(
              tag: 'hero-settings-button',
              child: RawButton.extended(
                color: Colors.green,
                onTap: () => const SettingScreenRoute().push(context),
                child: const Text(
                  'Manage Progressor and Settings',
                  style: Styles.boldWhite,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

extension on HomeScreenState {
  Future<void> _navigateTo(String route) async {
    if (!Simulator.enabled && progressor == null) {
      const SettingScreenRoute().push(context);
    }
    (switch (route) {
      LiveData.name => const LiveDataRoute().go,
      MVCTesting.name => const NewMVCTestRoute().go,
      ExerciseMode.name => const NewExerciseRoute().go,
      _ => throw UnimplementedError('Invalid route name: [$route]'),
    })(context);
  }
}

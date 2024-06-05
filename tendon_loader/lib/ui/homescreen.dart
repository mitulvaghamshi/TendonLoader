import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tendon_loader/handlers/bluetooth_handler.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/ui/screens/exercise_mode.dart';
import 'package:tendon_loader/ui/screens/live_data.dart';
import 'package:tendon_loader/ui/screens/mvc_testing.dart';
import 'package:tendon_loader/ui/widgets/app_logo.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/simulator.dart';

@immutable
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Hero(tag: 'hero-app-logo', child: AppLogo.square()),
      RawButton.tile(
        color: Colors.orange,
        onTap: () => _navigateTo(context, LiveData.name),
        child: const Text(LiveData.name, style: Styles.boldWhite),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        color: Colors.orange,
        onTap: () => _navigateTo(context, MVCTesting.name),
        child: const Text(MVCTesting.name, style: Styles.boldWhite),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        color: Colors.orange,
        onTap: () => _navigateTo(context, ExerciseMode.name),
        child: const Text(ExerciseMode.name, style: Styles.boldWhite),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        color: Colors.indigo,
        child: const Text('Explore Session', style: Styles.boldWhite),
        onTap: () => const UserListRoute().go(context),
      ),
      const SizedBox(height: 8),
      Hero(
        tag: 'hero-settings-button',
        child: RawButton.tile(
          color: Colors.green,
          onTap: () => const SettingScreenRoute().push(context),
          child: const Text('App Settings', style: Styles.boldWhite),
        ),
      ),
    ]);
  }
}

extension on HomeScreen {
  Future<void> _navigateTo(BuildContext context, String route) async {
    if (!Simulator.enabled && Progressor.instance.progressor == null) {
      const SettingScreenRoute().push(context);
    }
    (switch (route) {
      LiveData.name => const LiveDataRoute().push,
      MVCTesting.name => const NewMVCTestRoute().push,
      ExerciseMode.name => const NewExerciseRoute().push,
      _ => const InvalidRoute(message: 'Invalid entry').push,
    })(context);
  }
}

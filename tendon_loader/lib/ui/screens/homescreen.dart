import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tendon_loader/handlers/bluetooth_handler.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/ui/screens/settings_screen.dart';
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
      const AppLogo(radius: 150, padding: EdgeInsets.all(15)),
      RawButton.tile(
        color: Colors.orange,
        onTap: () => _navigateTo(context, LiveDataRoute.name),
        child: const Text(LiveDataRoute.name, style: Styles.whiteBold),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        color: Colors.orange,
        onTap: () => _navigateTo(context, MVCTestingRoute.name),
        child: const Text(MVCTestingRoute.name, style: Styles.whiteBold),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        color: Colors.orange,
        onTap: () => _navigateTo(context, ExerciseModeRoute.name),
        child: const Text(ExerciseModeRoute.name, style: Styles.whiteBold),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        color: Colors.indigo,
        child: const Text('Explore Session', style: Styles.whiteBold),
        onTap: () => const UserListRoute().go(context),
      ),
      const SizedBox(height: 8),
      Hero(
        tag: SettingsScreen.tag,
        child: RawButton.tile(
          color: Colors.green,
          onTap: () => const SettingScreenRoute().push(context),
          child: const Text('App Settings', style: Styles.whiteBold),
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
      LiveDataRoute.name => const LiveDataRoute().push,
      MVCTestingRoute.name => const NewMVCTestRoute().push,
      ExerciseModeRoute.name => const NewExerciseRoute().push,
      _ => const InvalidRoute(message: 'Invalid entry').push,
    })(context);
  }
}

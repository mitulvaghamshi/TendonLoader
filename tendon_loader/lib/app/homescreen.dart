import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tendon_loader/app/bluetooth/models/bluetooth_handler.dart';
import 'package:tendon_loader/app/bluetooth/models/simulator.dart';
import 'package:tendon_loader/app/exercise/exercise_mode.dart';
import 'package:tendon_loader/app/livedata/live_data.dart';
import 'package:tendon_loader/app/mvctest/mvc_testing.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/widgets/image_widget.dart';
import 'package:tendon_loader/widgets/raw_button.dart';

@immutable
final class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

final class HomeScreenState extends State<HomeScreen> with Progressor {
  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tendon Loader')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const Hero(tag: 'hero-app-logo', child: AppLogo.square()),
          const SizedBox(height: 30),
          RawButton.tile(
            color: Colors.orange,
            onTap: () => _navigateTo(LiveData.name),
            child: const Text(LiveData.name, style: Styles.boldWhite),
          ),
          const SizedBox(height: 8),
          RawButton.tile(
            color: Colors.orange,
            onTap: () => _navigateTo(MVCTesting.name),
            child: const Text(MVCTesting.name, style: Styles.boldWhite),
          ),
          const SizedBox(height: 8),
          RawButton.tile(
            color: Colors.orange,
            onTap: () => _navigateTo(ExerciseMode.name),
            child: const Text(ExerciseMode.name, style: Styles.boldWhite),
          ),
          const SizedBox(height: 8),
          Hero(
            tag: 'hero-settings-button',
            child: RawButton.tile(
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
    );
  }
}

extension on HomeScreenState {
  Future<void> _navigateTo(String route) async {
    if (!Simulator.enabled && progressor == null) {
      const SettingScreenRoute().push(context);
    }
    (switch (route) {
      LiveData.name => const LiveDataRoute().push,
      MVCTesting.name => const NewMVCTestRoute().push,
      ExerciseMode.name => const NewExerciseRoute().push,
      _ => throw UnimplementedError('Invalid route name: [$route]'),
    })(context);
  }
}

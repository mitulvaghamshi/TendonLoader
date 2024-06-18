import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tendon_loader/handlers/bluetooth_handler.dart';
import 'package:tendon_loader/router/router.dart';
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
      const AppLogo(radius: 130, padding: EdgeInsets.all(16)),
      const SizedBox(height: 8),
      RawButton.tile(
        color: Colors.orange,
        onTap: () => _safePush(context, const LiveDataRoute().push),
        child: const Text(LiveDataRoute.name, style: Styles.whiteBold),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        color: Colors.orange,
        onTap: () => _safePush(context, const MVCTestingRoute().push),
        child: const Text(MVCTestingRoute.name, style: Styles.whiteBold),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        color: Colors.orange,
        onTap: () => _safePush(context, const PrescriptionRoute().push),
        child: const Text(ExerciseModeRoute.name, style: Styles.whiteBold),
      ),
      const Divider(),
      RawButton.tile(
        color: Colors.indigo,
        onTap: () => const UserListRoute().go(context),
        child: const Text('Explore Session', style: Styles.whiteBold),
      ),
      const Divider(),
      RawButton.tile(
        color: Colors.green,
        onTap: () => const SettingScreenRoute().push(context),
        child: const Text(SettingScreenRoute.name, style: Styles.whiteBold),
      ),
    ]);
  }
}

extension on HomeScreen {
  Future<void> _safePush(
    BuildContext context,
    Future<T?> Function<T>(BuildContext) push,
  ) async {
    if (Simulator.enabled) return push(context);
    if (Progressor.instance.progressor != null) return push(context);
    const SettingScreenRoute().push(context);
  }
}

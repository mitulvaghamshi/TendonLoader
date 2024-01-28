import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:tendon_loader/handlers/bluetooth_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/ui/bluetooth/connected_list.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/simulator.dart';

@immutable
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const RawButton.tile(
        padding: EdgeInsets.zero,
        axisAlignment: MainAxisAlignment.start,
        child: Text('Record Sessions'),
      ),
      RawButton.tile(
        onTap: () => _safePush(context, const LiveDataRoute().push),
        color: Colors.orange,
        child: const Text(LiveDataRoute.name, style: Styles.whiteBold),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        onTap: () => _safePush(context, const MVCTestingRoute().push),
        color: Colors.orange,
        child: const Text(MVCTestingRoute.name, style: Styles.whiteBold),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        onTap: () => _safePush(context, const ExerciseModeRoute().push),
        color: Colors.orange,
        child: const Text(ExerciseModeRoute.name, style: Styles.whiteBold),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        onTap: () => const PrescriptionRoute().push(context),
        color: Colors.green,
        child: const Text('Prescriptions', style: Styles.whiteBold),
      ),
      const RawButton.tile(
        padding: EdgeInsets.zero,
        axisAlignment: MainAxisAlignment.start,
        child: Text('Session Data & App Settings'),
      ),
      RawButton.tile(
        onTap: () => const UserListRoute().go(context),
        color: Colors.indigo,
        child: const Text('View Session Data', style: Styles.whiteBold),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        onTap: () => _manageProgressor(context),
        color: Colors.green,
        child: const Text('Progressor Device', style: Styles.whiteBold),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        onTap: () => const SettingScreenRoute().push(context),
        color: Colors.blueGrey,
        child: const Text(SettingScreenRoute.name, style: Styles.whiteBold),
      ),
      const Divider(),
      RawButton.tile(
        onTap: _signOut,
        color: Colors.red,
        child: const Text('Sign out', style: Styles.whiteBold),
      ),
    ]);
  }
}

extension on HomeScreen {
  Future<void> _signOut() async {
    throw UnimplementedError('Logout not implemented');
  }

  Future<void> _safePush(
    final BuildContext context,
    final Future<T?> Function<T>(BuildContext context) push,
  ) async {
    if (Simulator.enabled) return push(context);
    if (Progressor.instance.progressor != null) return push(context);
    const SettingScreenRoute().push(context);
  }

  Future<void> _connectProgressor(final BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => const ConnectedList(),
    );
    await Progressor.instance.stopProgressor();
    GraphHandler.clear();
  }

  Future<void> _manageProgressor(final BuildContext context) async {
    if (Progressor.instance.progressor == null) {
      return _connectProgressor(context);
    }
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(Progressor.instance.deviceName),
        icon: const Icon(Icons.bluetooth),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          RawButton.tile(
            onTap: Progressor.instance.disconnect,
            color: Colors.orange,
            child: const Text('Disconnect', style: Styles.whiteBold),
          ),
          const SizedBox(height: 8),
          RawButton.tile(
            onTap: Progressor.instance.sleep,
            color: Colors.green,
            child: const Text('Sleep', style: Styles.whiteBold),
          ),
        ]),
      ),
    );
  }
}

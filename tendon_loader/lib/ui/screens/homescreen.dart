import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:tendon_loader/handlers/bluetooth_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/ui/bluetooth/connected_list.dart';
import 'package:tendon_loader/ui/widgets/button_factory.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/simulator.dart';

@immutable
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ButtonFactory.tile(
          padding: EdgeInsets.zero,
          axisAlignment: MainAxisAlignment.start,
          child: Text('Play & Learn'),
        ),
        ButtonFactory.tile(
          onTap: () => _safePush(context, const LiveDataRoute().push),
          color: Theme.of(context).primaryColorDark,
          child: const Text(LiveDataRoute.name, style: Styles.whiteBold),
        ),
        const ButtonFactory.tile(
          padding: EdgeInsets.zero,
          axisAlignment: MainAxisAlignment.start,
          child: Text('Record Sessions'),
        ),
        const SizedBox(height: 8),
        ButtonFactory.tile(
          onTap: () => _safePush(context, const MVCTestingRoute().push),
          color: Theme.of(context).primaryColorDark,
          child: const Text(MVCTestingRoute.name, style: Styles.whiteBold),
        ),
        const SizedBox(height: 8),
        ButtonFactory.tile(
          onTap: () => _safePush(context, const ExerciseModeRoute().push),
          color: Theme.of(context).primaryColorDark,
          child: const Text(ExerciseModeRoute.name, style: Styles.whiteBold),
        ),
        const SizedBox(height: 8),
        ButtonFactory.tile(
          onTap: () => const PrescriptionRoute().push(context),
          color: Theme.of(context).primaryColor,
          child: const Text('Customize Prescriptions', style: Styles.whiteBold),
        ),
        const ButtonFactory.tile(
          padding: EdgeInsets.zero,
          axisAlignment: MainAxisAlignment.start,
          child: Text('Session Data & App Settings'),
        ),
        ButtonFactory.tile(
          onTap: () => const UserListRoute().go(context),
          color: Theme.of(context).primaryColor,
          child: const Text('Manage Data', style: Styles.whiteBold),
        ),
        const SizedBox(height: 8),
        ButtonFactory.tile(
          onTap: () => _manageProgressor(context),
          color: Theme.of(context).primaryColor,
          child: const Text('Progressor Connection', style: Styles.whiteBold),
        ),
        const SizedBox(height: 8),
        ButtonFactory.tile(
          onTap: () => const SettingScreenRoute().push(context),
          color: Theme.of(context).shadowColor,
          child: const Text(SettingScreenRoute.name, style: Styles.whiteBold),
        ),
        const Divider(),
        ButtonFactory.tile(
          onTap: _signOut,
          color: Colors.red,
          child: const Text('Sign out', style: Styles.whiteBold),
        ),
      ],
    );
  }
}

extension on HomeScreen {
  Future<void> _signOut() async {
    throw UnimplementedError('Logout not implemented');
  }

  Future<void> _safePush(
    BuildContext context,
    Future<T?> Function<T>(BuildContext) push,
  ) async {
    if (Simulator.enabled) {
      return push(context);
    }
    if (Progressor.instance.progressor != null) {
      return push(context);
    }
    const SettingScreenRoute().push(context);
  }

  Future<void> _connectProgressor(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => const ConnectedList(),
    );
    await Progressor.instance.stopProgressor();
    GraphHandler.clear();
  }

  Future<void> _manageProgressor(BuildContext context) async {
    if (Progressor.instance.progressor == null) {
      return _connectProgressor(context);
    }
    await showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(Progressor.instance.deviceName),
          icon: const Icon(Icons.bluetooth),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ButtonFactory.tile(
                onTap: Progressor.instance.disconnect,
                color: Colors.orange,
                child: const Text('Disconnect', style: Styles.whiteBold),
              ),
              const SizedBox(height: 8),
              ButtonFactory.tile(
                onTap: Progressor.instance.sleep,
                color: Colors.green,
                child: const Text('Sleep', style: Styles.whiteBold),
              ),
            ],
          ),
        );
      },
    );
  }
}

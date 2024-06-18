import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/handlers/bluetooth_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/states/app_scope.dart';
import 'package:tendon_loader/ui/bluetooth/connected_list.dart';
import 'package:tendon_loader/ui/widgets/app_logo.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final state = AppScope.of(context);
  late final _scaleCtrl = TextEditingController()
    ..text = state.settings.graphScale.toString();

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const length = 0;
    return AnimatedBuilder(
      animation: state,
      child: RawButton.tile(
        onTap: () {},
        color: Colors.green,
        leading: const Icon(Icons.person, color: Colors.white),
        trailing: const Icon(Icons.edit, color: Colors.white),
        child: Text(
          state.user.username,
          overflow: TextOverflow.ellipsis,
          style: Styles.whiteBold,
          maxLines: 1,
        ),
      ),
      builder: (context, child) => Column(children: [
        child!,
        const SizedBox(height: 8),
        ListTile(
          onTap: _uploadData,
          enabled: length > 0,
          contentPadding: Styles.tilePadding,
          title: const Text('Locally stored data'),
          subtitle: const Text('Submit panding data to the server.'),
          trailing: Text(length.toString(), style: Styles.bold18),
        ),
        ListTile(
          contentPadding: Styles.tilePadding,
          title: const Text('Y-axis scale (default: 30kg)'),
          subtitle: const Text('Adjust visible area of the graph.'),
          trailing: SizedBox(
            width: 60,
            child: TextField(
              style: Styles.bold18,
              controller: _scaleCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d{1,2}(\.\d{0,2})?'),
                ),
              ],
              onChanged: (value) => state.update<Settings>((settings) {
                final gscale = double.tryParse(value) ?? 30.0;
                return settings.copyWith(graphScale: gscale);
              }),
            ),
          ),
        ),
        SwitchListTile(
          contentPadding: Styles.tilePadding,
          title: const Text('Use dark mode'),
          subtitle: const Text('Use dark interface.'),
          value: state.settings.darkMode,
          onChanged: (value) => state.update<Settings>((settings) {
            return settings.copyWith(darkMode: value);
          }),
        ),
        SwitchListTile(
          contentPadding: Styles.tilePadding,
          title: const Text('Automatic data upload'),
          subtitle: const Text('Exercises submitted automatically.'),
          value: state.settings.autoUpload,
          onChanged: (value) => state.update<Settings>((settings) {
            return settings.copyWith(autoUpload: value);
          }),
        ),
        const SizedBox(height: 8),
        RawButton.tile(
          onTap: () => const PrescriptionRoute().push(context),
          color: Colors.green,
          child: const Text('Prescriptions', style: Styles.whiteBold),
        ),
        const SizedBox(height: 8),
        RawButton.tile(
          onTap: Progressor.instance.progressor == null
              ? _connectProgressor
              : _manageProgressor,
          color: Colors.indigo,
          child: Text(
            Progressor.instance.progressor == null
                ? 'Connect Progressor'
                : 'Manage Progressor',
            style: Styles.whiteBold,
          ),
        ),
        const SizedBox(height: 8),
        RawButton.tile(
          onTap: _aboutDialog,
          color: Colors.orange,
          child: const Text('About', style: Styles.whiteBold),
        ),
        const SizedBox(height: 8),
        RawButton.tile(
          onTap: () => throw UnimplementedError('Sign out not implemented'),
          color: Colors.red,
          child: const Text('Sign out', style: Styles.whiteBold),
        ),
      ]),
    );
  }
}

extension on _SettingsScreenState {
  Future<void> _connectProgressor() async {
    await showDialog<void>(
      context: context,
      builder: (_) => const ConnectedList(),
    );
    await Progressor.instance.stopProgressor();
    GraphHandler.clear();
  }

  Future<void> _manageProgressor() async {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(Progressor.instance.deviceName),
        icon: const Icon(Icons.bluetooth),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          RawButton.tile(
            onTap: _manageProgressor,
            color: Colors.orange,
            child: const Text('Disconnect', style: Styles.whiteBold),
          ),
          const SizedBox(height: 8),
          RawButton.tile(
            onTap: _manageProgressor,
            color: Colors.green,
            child: const Text('Sleep', style: Styles.whiteBold),
          ),
        ]),
      ),
    );
  }

  Future<void> _uploadData() async {
    const int count = 0; // await model.uploadExports();
    if (context.mounted) {
      final messanger = ScaffoldMessenger.of(context);
      final banner = MaterialBanner(
        content: const Text(count == -1 //
            ? 'No network connection'
            : 'Uploaded $count exports'),
        actions: [
          TextButton(
            onPressed: messanger.clearMaterialBanners,
            child: const Text('Dismiss'),
          )
        ],
      );
      messanger.showMaterialBanner(banner);
    }
  }

  void _aboutDialog() {
    showAboutDialog(
      context: context,
      applicationVersion: 'v1.0.0',
      applicationName: 'Tendon Loader',
      applicationLegalese: 'Copyright © 2024, Mitul Vaghamshi.',
      applicationIcon: const AppLogo(radius: 50),
      children: [
        const Divider(thickness: 2),
        const Text(
          'Tendon Loader is designed to measure and help cure '
          "Achille's (uh-KILL-eez) Tendon Problems.",
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('Contact:'),
        ),
        const Text('mitulvaghmashi@gmail.com'),
      ],
    );
  }
}

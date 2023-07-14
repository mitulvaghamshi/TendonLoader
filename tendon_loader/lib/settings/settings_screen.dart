import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/app/bluetooth/models/bluetooth_handler.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/widgets/app_logo.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/settings/settings.dart';
import 'package:tendon_loader/settings/settings_service.dart';
import 'package:tendon_loader/states/app_scope.dart';

@immutable
final class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

final class SettingsScreenState extends State<SettingsScreen> with Progressor {
  late final service = AppScope.of(context).service;
  late final _scaleCtrl = TextEditingController()
    ..text = service.settings.graphScale.toString();

  @override
  void dispose() {
    if (service.modified) {
      service.modified = false;
      SettingsService.update(service.settings);
    }
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const length = 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnimatedBuilder(
          animation: service,
          builder: (context, child) => Column(children: [
            RawButton.tile(
              onTap: () {},
              color: Colors.green,
              leading: const Icon(Icons.person, color: Colors.white),
              child: Text(
                service.user!.username,
                overflow: TextOverflow.ellipsis,
                style: Styles.boldWhite,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: Styles.tilePadding,
              title: const Text('Use dark mode'),
              subtitle: const Text('Use dark interface.'),
              value: service.settings.darkMode,
              onChanged: (value) => service.get<Settings>((settings) {
                return settings.copyWith(darkMode: value);
              }),
            ),
            SwitchListTile(
              contentPadding: Styles.tilePadding,
              title: const Text('Automatic data upload'),
              subtitle: const Text('Exercises submitted automatically.'),
              value: service.settings.autoUpload,
              onChanged: (value) => service.get<Settings>((settings) {
                return settings.copyWith(autoUpload: value);
              }),
            ),
            SwitchListTile(
              contentPadding: Styles.tilePadding,
              title: const Text('Use custom prescriptions'),
              subtitle: const Text('Create your own prescriptions.'),
              value: service.settings.editablePrescription,
              onChanged: (value) => service.get<Settings>((settings) {
                return settings.copyWith(editablePrescription: value);
              }),
            ),
            ListTile(
              enabled: length > 0,
              contentPadding: Styles.tilePadding,
              title: const Text('Locally stored data'),
              subtitle: const Text('Submit panding data to the server.'),
              trailing: Text(length.toString(), style: Styles.titleStyle),
              onTap: _uploadData,
            ),
            ListTile(
              contentPadding: Styles.tilePadding,
              title: const Text('Y-axis scale (default: 30kg)'),
              subtitle: const Text('Adjust visible area of the graph.'),
              trailing: SizedBox(
                width: 60,
                child: TextField(
                  style: Styles.titleStyle,
                  controller: _scaleCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{1,2}(\.\d{0,2})?'),
                    ),
                  ],
                  onChanged: (value) => service.get<Settings>((settings) {
                    final gscale = double.tryParse(value) ?? 30.0;
                    return settings.copyWith(graphScale: gscale);
                  }),
                ),
              ),
            ),
            const SizedBox(height: 8),
            RawButton.tile(
              onTap: _manageProgressor,
              color: Colors.indigo,
              child: Text(
                progressor == null
                    ? 'Connect to Progressor'
                    : 'Manage Progressor Connection',
                style: Styles.boldWhite,
              ),
            ),
            const SizedBox(height: 8),
            RawButton.tile(
              onTap: _aboutDialog,
              color: Colors.orange,
              child: const Text('About', style: Styles.boldWhite),
            ),
            const SizedBox(height: 8),
            RawButton.tile(
              onTap: () => throw UnimplementedError('Sign out not implemented'),
              color: Colors.red,
              child: const Text('Sign out', style: Styles.boldWhite),
            ),
          ]),
        ),
      ),
    );
  }
}

extension on SettingsScreenState {
  Future<void> _manageProgressor() async {
    if (progressor == null) {
      return; // TODO(me): ignored during development
      // await showDialog<void>(
      //   context: context,
      //   builder: (_) => const ConnectedList(),
      // ).then((_) async => stopProgressor()
      //.then((_) => GraphHandler.clear()));
    } else {
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(progressorName),
          icon: const Icon(Icons.bluetooth),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RawButton.tile(
                onTap: _manageProgressor,
                color: Colors.orange,
                child: const Text(
                  'Disconnect',
                  style: Styles.boldWhite,
                ),
              ),
              const SizedBox(height: 8),
              RawButton.tile(
                onTap: _manageProgressor,
                color: Colors.green,
                child: const Text(
                  'Disconnect and Sleep',
                  style: Styles.boldWhite,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // TODO(me): Data upload
  Future<void> _uploadData() async {
    const int count = 0; // await model.uploadExports();
    if (context.mounted) {
      final messanger = ScaffoldMessenger.of(context);
      final banner = MaterialBanner(
        content: const Text(count == -1
            ? 'No network connection.'
            : 'Uploaded $count exports.'),
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
      applicationLegalese: 'Copyright © 2023, Mitul Vaghamshi.',
      applicationIcon: const SizedBox.square(
        dimension: 50,
        child: AppLogo(),
      ),
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

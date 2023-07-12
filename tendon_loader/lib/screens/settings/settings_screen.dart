import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/widgets/app_logo.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/network/app_scope.dart';
import 'package:tendon_loader/network/settings.dart';
import 'package:tendon_loader/screens/bluetooth/connected_list.dart';
import 'package:tendon_loader/screens/bluetooth/models/bluetooth_handler.dart';
import 'package:tendon_loader/screens/graph/models/graph_handler.dart';

@immutable
final class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> with Progressor {
  late final api = AppScope.of(context).api;
  late final _scaleCtrl = TextEditingController.fromValue(
    TextEditingValue(text: api.settings.graphScale.toString()),
  );

  @override
  void dispose() {
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
          animation: api,
          builder: (context, child) => Column(children: [
            RawButton.icon(
              onTap: () {},
              color: Colors.green,
              left: const Icon(Icons.person, color: Colors.white),
              right: Text(
                api.user!.username,
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
              value: api.settings.darkMode,
              onChanged: (value) => api.update<Settings>((settings) {
                return settings.copyWith(darkMode: value);
              }),
            ),
            SwitchListTile(
              contentPadding: Styles.tilePadding,
              title: const Text('Automatic data upload'),
              subtitle: const Text('Exercises submitted automatically.'),
              value: api.settings.autoUpload,
              onChanged: (value) => api.update<Settings>((settings) {
                return settings.copyWith(autoUpload: value);
              }),
            ),
            SwitchListTile(
              contentPadding: Styles.tilePadding,
              title: const Text('Use custom prescriptions'),
              subtitle: const Text('Create your own prescriptions.'),
              value: api.settings.editablePrescription,
              onChanged: (value) => api.update<Settings>((settings) {
                return api.settings.copyWith(editablePrescription: value);
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
                  onChanged: (value) => api.update<Settings>((settings) {
                    final gscale = double.tryParse(value) ?? 30.0;
                    return settings.copyWith(graphScale: gscale);
                  }),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{1,2}(\.\d{0,2})?'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (progressor == null)
              RawButton.extended(
                color: Colors.indigo,
                onTap: _connectProgressor,
                child: const Text(
                  'Connect to Progressor',
                  style: Styles.boldWhite,
                ),
              )
            else
              ListTile(
                contentPadding: Styles.tilePadding,
                title: Text(
                  'Disconnect ($progressorName)',
                  style: const TextStyle(color: Color(0xffff534d)),
                ),
                subtitle: const Text('Long press to sleep the progressor'),
                onTap: disconnect,
                onLongPress: () async => disconnect(sleep: true),
              ),
            const SizedBox(height: 8),
            RawButton.extended(
              onTap: _aboutDialog,
              color: Colors.orange,
              child: const Text('About', style: Styles.boldWhite),
            ),
            const SizedBox(height: 8),
            RawButton.extended(
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
  Future<void> _connectProgressor() async {
    await showDialog<void>(
      context: context,
      builder: (_) => const ConnectedList(),
    ).then((_) async => stopProgressor().then((_) => GraphHandler.clear()));
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
}

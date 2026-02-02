import 'package:api_server/api_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/pages/widgets/app_logo.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';
import 'package:tendon_loader/state/app_scope.dart';
import 'package:tendon_loader/state/app_state.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final state = context.read<AppState>();
  late final _scaleCtrl = TextEditingController(
    text: state.settings.graphScale.toString(),
  );

  final length = 0;

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: state,
    child: ButtonFactory.tile(
      onTap: () {},
      color: Theme.of(context).shadowColor,
      leading: const Icon(Icons.person, color: Colors.white),
      trailing: const Icon(Icons.edit, color: Colors.white),
      child: Text(
        state.authUser.username,
        maxLines: 1,
        overflow: .ellipsis,
        style: Styles.whiteBold,
      ),
    ),
    builder: (context, child) => Column(
      children: [
        child!,
        const Divider(),
        ListTile(
          onTap: _uploadData,
          enabled: length > 0,
          contentPadding: Styles.tilePadding,
          title: const Text('Pending uploads'),
          subtitle: const Text('Upload local data to the server'),
          trailing: Text(length.toString(), style: Styles.bold18),
        ),
        const Divider(),
        ListTile(
          contentPadding: Styles.tilePadding,
          title: const Text('Graph size (y-axis)'),
          subtitle: const Text('Adjust visible graph area'),
          trailing: SizedBox(
            width: 60,
            child: TextField(
              style: Styles.bold18,
              controller: _scaleCtrl,
              keyboardType: const .numberWithOptions(decimal: true),
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
        const Divider(),
        SwitchListTile(
          contentPadding: Styles.tilePadding,
          title: const Text('Dark mode'),
          subtitle: const Text('Use dark interface'),
          value: state.settings.darkMode,
          onChanged: (value) => state.update<Settings>((settings) {
            return settings.copyWith(darkMode: value);
          }),
        ),
        const Divider(),
        SwitchListTile(
          contentPadding: Styles.tilePadding,
          title: const Text('Auto-upload'),
          subtitle: const Text('Upload data automatically'),
          value: state.settings.autoUpload,
          onChanged: (value) => state.update<Settings>((settings) {
            return settings.copyWith(autoUpload: value);
          }),
        ),
        const Divider(),
        SwitchListTile(
          contentPadding: Styles.tilePadding,
          title: const Text('Custom prescriptions'),
          subtitle: const Text('Create custom prescriptions'),
          value: state.settings.editablePrescription,
          onChanged: (value) => state.update<Settings>((settings) {
            return settings.copyWith(editablePrescription: value);
          }),
        ),
        const Divider(),
        ButtonFactory.tile(
          onTap: _aboutDialog,
          color: Theme.of(context).shadowColor,
          child: const Text('About', style: Styles.whiteBold),
        ),
      ],
    ),
  );
}

extension on _SettingsScreenState {
  Future<void> _uploadData() async {
    const int count = 0; // await model.uploadExports();
    if (!mounted || count <= 0) return;
    const content = SnackBar(
      padding: .zero,
      content: ButtonFactory.error(
        color: Colors.indigo,
        message: 'Uploaded $count exports',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(content);
  }

  void _aboutDialog() => showAboutDialog(
    context: context,
    applicationVersion: 'v1.0',
    applicationName: 'Tendon Loader',
    applicationLegalese: '\u00a9 ${DateTime.now().year}, Mitul Vaghamshi.',
    applicationIcon: const AppLogo(radius: 20, padding: .only(top: 16)),
    children: [
      const Divider(),
      const Text(
        'Tendon Loader is designed to measure and help cure '
        "Achille's (uh-KILL-eez) Tendon Problems.\n\n"
        'This app is currently in beta and is not intended for medical use.\n\n'
        'For more information, please visit the '
        'app website or contact the developer.',
      ),
      const Divider(),
      const Text('Email: mitulvaghmashi@gmail.com'),
    ],
  );
}

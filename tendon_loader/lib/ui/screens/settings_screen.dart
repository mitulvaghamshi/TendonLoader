import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/states/app_scope.dart';
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
          subtitle: const Text('Upload local files to the server'),
          trailing: Text(length.toString(), style: Styles.bold18),
        ),
        ListTile(
          contentPadding: Styles.tilePadding,
          title: const Text('Graph scale (y-axis)'),
          subtitle: const Text('Adjust visible area of the graph'),
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
          subtitle: const Text('Use dark interface'),
          value: state.settings.darkMode,
          onChanged: (value) => state.update<Settings>((settings) {
            return settings.copyWith(darkMode: value);
          }),
        ),
        SwitchListTile(
          contentPadding: Styles.tilePadding,
          title: const Text('Automatic data upload'),
          subtitle: const Text('Session data submitted automatically'),
          value: state.settings.autoUpload,
          onChanged: (value) => state.update<Settings>((settings) {
            return settings.copyWith(autoUpload: value);
          }),
        ),
        SwitchListTile(
          contentPadding: Styles.tilePadding,
          title: const Text('Use custom prescriptions'),
          subtitle: const Text('Create custom prescriptions'),
          value: state.settings.editablePrescription,
          onChanged: (value) => state.update<Settings>((settings) {
            return settings.copyWith(editablePrescription: value);
          }),
        ),
        const Divider(),
        RawButton.tile(
          onTap: _aboutDialog,
          color: Colors.blueGrey,
          child: const Text('About', style: Styles.whiteBold),
        ),
      ]),
    );
  }
}

extension on _SettingsScreenState {
  Future<void> _uploadData() async {
    // TODO(mitul): Implement data upload...
    const int count = 0; // await model.uploadExports();
    if (!mounted || count <= 0) return;
    const content = SnackBar(
      padding: EdgeInsets.all(0),
      content: RawButton.error(
        color: Colors.indigo,
        message: 'Uploaded $count exports',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(content);
  }

  void _aboutDialog() {
    showAboutDialog(
      context: context,
      applicationVersion: 'v1.0',
      applicationName: 'Tendon Loader',
      applicationLegalese: '© 2024, Mitul Vaghamshi',
      children: [
        const Divider(),
        const AppLogo(radius: 100, padding: EdgeInsets.all(16)),
        const SizedBox(height: 8),
        const Text(
          'Tendon Loader is designed to measure and help cure '
          "Achille's (uh-KILL-eez) Tendon Problems.",
        ),
        const SizedBox(height: 16),
        const Divider(),
        const Text('Contact:'),
        const Text('mitulvaghmashi@gmail.com'),
      ],
    );
  }
}

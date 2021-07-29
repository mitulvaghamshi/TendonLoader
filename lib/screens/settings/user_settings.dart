import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/handlers/auth_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/screens/homescreen.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/screens/login/splash.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  static const String route = '/userSettings';

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  late final TextEditingController _ctrlGraphSize = TextEditingController()
    ..text = context.model.settingsState!.graphSize.toString()
    ..addListener(() => context.model.settingsState!.graphSize = double.tryParse(_ctrlGraphSize.text) ?? 30);

  @override
  void dispose() {
    _ctrlGraphSize.dispose();
    super.dispose();
  }

  Future<void> _tryUpload() async {
    if (await tryUpload(context) ?? true) {
      context.view.refresh();
    } else {
      context.showSnackBar(const Text('No data available! or already submitted.'));
    }
  }

  Future<void> _logout() async {
    context.model.userState!.keepSigned = false;
    await context.model.userState!.save();
    await context.model.settingsState!.save();
    await firebaseLogout().then((_) => context.push(Login.route, replace: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), actions: <Widget>[
        Switch.adaptive(
          value: isSumulation,
          activeColor: colorRed400,
          onChanged: (bool value) => setState(() => isSumulation = value),
        ),
      ]),
      body: SingleChildScrollView(
        child: AppFrame(
          onExit: () => context.model.settingsState!.save().then((_) => true),
          child: Column(children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: CustomImage()),
            FittedBox(
              child: CustomButton(
                left: const Icon(Icons.person_rounded, size: 30),
                right: Text(
                  context.model.currentUser!.id,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField(
                controller: _ctrlGraphSize,
                format: r'^\d{1,3..}(\.\d{0,2})?',
                label: 'Y-Axis Size (default: 30 Kg)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const Divider(),
            SwitchListTile.adaptive(
              activeColor: colorGoogleGreen,
              title: const Text('Automatic data upload'),
              value: context.model.settingsState!.autoUpload!,
              subtitle: const Text('Automatically upload exercise and mvc test data on completion.'),
              onChanged: (bool value) => setState(() => context.model.settingsState!.autoUpload = value),
            ),
            const Divider(),
            SwitchListTile.adaptive(
              activeColor: colorGoogleGreen,
              title: const Text('Use custom prescriptions'),
              value: context.model.settingsState!.customPrescriptions!,
              onChanged: (bool value) => setState(() {
                context.model.settingsState!.customPrescriptions = value;
                context.model.togglePrescription();
              }),
              subtitle: const Text('Provide your own prescriptions for exercise and mvc test.'),
            ),
            const Divider(),
            ListTile(
              title: const Text('Locally stored data'),
              subtitle: const Text('Press button to upload any unsubmitted data.'),
              trailing: CustomButton(
                rounded: true,
                onPressed: _tryUpload,
                left: Text(boxExport.length.toString(), style: tsR18B),
              ),
            ),
            const Divider(),
            const AboutListTile(
              applicationVersion: 'v0.0.9',
              applicationName: 'Tendon Loader',
              applicationIcon: SizedBox(height: 50, width: 50, child: CustomImage()),
              aboutBoxChildren: <Widget>[Text('Tendon Loader :Preview', textAlign: TextAlign.center, style: tsG18BFF)],
              child: Text('About'),
            ),
            const Divider(),
            ListTile(onTap: _logout, title: const Text('Logout', style: TextStyle(color: colorRed400))),
          ]),
        ),
      ),
    );
  }
}

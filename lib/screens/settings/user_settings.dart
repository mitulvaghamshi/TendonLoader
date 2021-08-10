import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/handlers/auth_handler.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/main.dart';
import 'package:tendon_loader/screens/homescreen.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  static const String route = '/userSettings';

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  late final TextEditingController _ctrlGraphScale = TextEditingController()
    ..text = context.model.settingsState!.graphSize.toString();

  @override
  void dispose() {
    _ctrlGraphScale.dispose();
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

  Future<bool> _onExit() async {
    final double? scale = double.tryParse(_ctrlGraphScale.text);
    if (scale != null && scale > 0) context.model.settingsState!.graphSize = scale;
    return context.model.settingsState!.save().then((_) => true);
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
          onExit: _onExit,
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
              child: Column(children: <Widget>[
                CustomTextField(
                  controller: _ctrlGraphScale,
                  format: r'^\d{1,2}(\.\d{0,2})?',
                  label: 'Y-Axis Scale (default: 30 Kg)',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 5),
                const Text('Consult your clinician before modifying the axis scale value.'),
              ]),
            ),
            const Divider(),
            SwitchListTile.adaptive(
              activeColor: colorBlue,
              title: const Text('Automatic data upload'),
              value: context.model.settingsState!.autoUpload!,
              subtitle: const Text('Automatically upload exercise and mvc test data on completion.'),
              onChanged: (bool value) => setState(() => context.model.settingsState!.autoUpload = value),
            ),
            const Divider(),
            SwitchListTile.adaptive(
              activeColor: colorBlue,
              title: const Text('Use custom prescriptions'),
              value: context.model.settingsState!.customPrescriptions!,
              subtitle: const Text('Provide your own prescriptions for exercise and mvc test.'),
              onChanged: (bool value) => setState(() {
                context.model.settingsState!.toggleCustom(value, context.model.currentUser!);
              }),
            ),
            const Divider(),
            ListTile(
              onTap: _tryUpload,
              title: const Text('Locally stored data'),
              subtitle: const Text('Click here to submit locally stored data to clinician.'),
              trailing: CustomButton(rounded: true, left: Text(boxExport.length.toString(), style: ts22B)),
            ),
            if (progressor != null) ...<Widget>[
              const Divider(),
              ListTile(
                title: Text('Disconnect ($deviceName)'),
                onTap: () => disconnectDevice().then((_) => setState(() {})),
              ),
            ],
            const Divider(),
            const AboutListTile(
              applicationVersion: 'v0.0.11',
              applicationName: 'Tendon Loader',
              applicationIcon: SizedBox(height: 50, width: 50, child: CustomImage()),
              aboutBoxChildren: <Widget>[Text('Tendon Loader :Preview', textAlign: TextAlign.center, style: tsG18B)],
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

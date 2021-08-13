import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tendon_loader/bluetooth/device_handler.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/emulator.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  static const String route = '/userSettings';

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  late final TextEditingController _ctrlGraphScale = TextEditingController()
    ..text = context.settingsState.graphSize.toString();

  @override
  void dispose() {
    _ctrlGraphScale.dispose();
    super.dispose();
  }

  Future<void> _tryUpload() async {
    if (await tryUpload(context) ?? true) {
      setState(() {});
    } else {
      context.showSnackBar(const Text('No data available! or already submitted.'));
    }
  }

  Future<void> _logout() async {
    context.userState.keepSigned = false;
    await context.userState.save();
    await context.settingsState.save();
    await signout();
    await context.logout();
  }

  Future<bool> _onExit() async {
    final double? scale = double.tryParse(_ctrlGraphScale.text);
    if (scale != null && scale > 0) context.settingsState.graphSize = scale;
    return context.settingsState.save().then((_) => true);
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
            const CustomImage(),
            FittedBox(
              child: CustomButton(
                left: const Icon(Icons.person, size: 30),
                right: Text(context.patient.id, style: ts22B),
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
              value: context.settingsState.autoUpload!,
              title: const Text('Automatic data upload'),
              subtitle: const Text('Automatically upload exercise and mvc test data on completion.'),
              onChanged: (bool value) => setState(() => context.settingsState.autoUpload = value),
            ),
            const Divider(),
            SwitchListTile.adaptive(
              activeColor: colorBlue,
              title: const Text('Use custom prescriptions'),
              value: context.settingsState.customPrescriptions!,
              subtitle: const Text('Provide your own prescriptions for exercise and mvc test.'),
              onChanged: (bool value) => setState(() {
                context.settingsState.toggleCustom(value, context.patient);
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
                subtitle: const Text('Long pres to sleep progressor'),
                onLongPress: () => disconnectDevice().then((_) => setState(() {})),
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

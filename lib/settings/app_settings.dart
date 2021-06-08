import 'package:flutter/material.dart';
import 'package:tendon_loader/login/app_auth.dart';
import 'package:tendon_loader/settings/settings_model.dart';
import 'package:tendon_loader/settings/settings_handler.dart';
import 'package:tendon_loader/login/login.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  static const String route = '/settings';

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: AppFrame(
          onExit: updateSettings,
          child: Column(children: <Widget>[
            FittedBox(
              child: Row(
                children: <Widget>[
                  const AppLogo(size: 70),
                  const SizedBox(width: 20),
                  Text(
                    SettingsModel.userId!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: SettingsModel.autoUpload!,
              title: const Text('Automatic data upload'),
              onChanged: (bool value) => setState(() => SettingsModel.autoUpload = value),
              subtitle: const Text(
                'If device is connected to the internet, data is transfered to the cloud right away. '
                'Or, data stored locally, and auto uploaded on launch.',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.justify,
              ),
            ),
            SwitchListTile(
              value: SettingsModel.editableExercise!,
              title: const Text('Editable exercise mode *UNDER PROCESS'),
              onChanged: (bool value) => setState(() => SettingsModel.editableExercise = value),
              subtitle: const Text(
                'If enabled user allowed to fill up their own exercise prescriptions. '
                'Othervise, it will be auto filled by the clinitian.',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.justify,
              ),
            ),
            const Divider(thickness: 2),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                await signOut();
                await Navigator.pushReplacementNamed(context, Login.route);
              },
            ),
          ]),
        ),
      ),
    );
  }
}

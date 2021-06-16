import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/handler/dialog_handler.dart';
import 'package:tendon_loader/login/app_auth.dart';
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
          onExit: AppStateScope.of(context).updateSettings,
          child: Column(children: <Widget>[
            const AppLogo(size: 150),
            const SizedBox(height: 30),
            Text(
              AppStateScope.of(context).userId!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
            const SizedBox(height: 30),
            SwitchListTile.adaptive(
              value: AppStateScope.of(context).autoUpload!,
              title: const Text('Automatic data upload'),
              onChanged: (bool value) => setState(() => AppStateScope.of(context).autoUpload = value),
              subtitle: const Text(
                'If device is connected to the internet, data is transfered to the cloud right away. '
                'Or, data stored locally, and auto uploaded on launch.',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              value: AppStateScope.of(context).filedEditable!,
              title: const Text('Editable exercise mode *Data?'),
              onChanged: (bool value) => setState(() => AppStateScope.of(context).filedEditable = value),
              subtitle: const Text(
                'If enabled user allowed to fill up their own exercise prescriptions. '
                'Othervise, it will be auto filled by the clinitian.',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(title: const Text('Export data'), onTap: () async => manualExport(context)),
            const Divider(thickness: 2),
            ListTile(title: const Text('About'), onTap: () => aboutDialog(context)),
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

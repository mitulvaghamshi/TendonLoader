import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/constants/colors.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/handler/app_auth.dart';
import 'package:tendon_loader/handler/dialog_handler.dart';
import 'package:tendon_loader/login/login.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  static const String route = '/settings';

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  final TextEditingController _ctrlGraphSize = TextEditingController();

  @override
  void dispose() {
    _ctrlGraphSize.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _ctrlGraphSize.addListener(() {
      AppStateScope.of(context).graphSize = double.tryParse(_ctrlGraphSize.text) ?? 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    _ctrlGraphSize.text = AppStateScope.of(context).graphSize.toString();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: AppFrame(
          onExit: AppStateScope.of(context).updateAppSettings,
          child: Column(children: <Widget>[
            const AppLogo(),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: () {},
              icon: const Icon(Icons.person_rounded, size: 30),
              child: Text(
                AppStateScope.of(context).currentUser.id,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile.adaptive(
              activeColor: colorGoogleGreen,
              title: const Text('Automatic data upload'),
              value: AppStateScope.of(context).autoUpload!,
              onChanged: (bool value) => setState(() => AppStateScope.of(context).autoUpload = value),
              subtitle: const Text(
                'If device is connected to the internet, data is transfered to the cloud right away. '
                'Or, data stored locally, and auto uploaded on launch.',
                style: TextStyle(fontSize: 12, color: colorGoogleGreen),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile.adaptive(
              activeColor: colorGoogleGreen,
              title: const Text('Editable exercise mode'),
              value: AppStateScope.of(context).fieldEditable!,
              onChanged: (bool value) => setState(() => AppStateScope.of(context).fieldEditable = value),
              subtitle: const Text(
                'If enabled user allowed to fill up their own exercise prescriptions. '
                'Othervise, it will be auto filled by the clinitian.',
                style: TextStyle(fontSize: 12, color: colorGoogleGreen),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(label: 'Graph size (default: 30 Kg)', controller: _ctrlGraphSize),
            const SizedBox(height: 10),
            ListTile(title: const Text('Export data'), onTap: () async => manualExport(context)),
            const Divider(thickness: 2),
            ListTile(title: const Text('About'), onTap: () => aboutDialog(context)),
            const Divider(thickness: 2),
            ListTile(
              title: const Text('Logout', style: TextStyle(color: colorRed400)),
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

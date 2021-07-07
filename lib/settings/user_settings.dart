import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/device/scanner_list.dart';
import 'package:tendon_loader/handler/device_handler.dart';
import 'package:tendon_loader/handler/dialog_handler.dart';
import 'package:tendon_loader/login/app_auth.dart';
import 'package:tendon_loader/login/login.dart';
import 'package:tendon_loader/utils/helper.dart';
import 'package:tendon_loader/utils/themes.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  static const String route = '/userSettings';

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  late final TextEditingController _ctrlGraphSize = TextEditingController()
    ..addListener(() {
      AppStateScope.of(context).settingsState!.graphSize = double.tryParse(_ctrlGraphSize.text) ?? 30;
    });

  @override
  void dispose() {
    _ctrlGraphSize.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ctrlGraphSize.text = AppStateScope.of(context).settingsState!.graphSize.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: AppFrame(
          onExit: () => AppStateScope.of(context).settingsState!.save().then((_) => true),
          child: Column(children: <Widget>[
            // testing only
            SwitchListTile.adaptive(
              value: simulateBT,
              tileColor: Colors.red,
              activeColor: googleGreen,
              title: const Text('Use without progressor', style: TextStyle(color: Colors.white, fontSize: 20)),
              onChanged: (bool value) => setState(() => simulateBT = value),
              subtitle: const Text(
                  'Use app without the progressor, generate and submit fake data '
                  'for MVC and Exercise Mode, testing perpose only!',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              collapsedBackgroundColor: Colors.red,
              title: const Text('Scan all devices.', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Click to start/stop scanning', style: TextStyle(color: Colors.white)),
              onExpansionChanged: (bool isOpen) async {
                if (isOpen) {
                  await FlutterBlue.instance.startScan(timeout: const Duration(seconds: 5));
                } else {
                  await FlutterBlue.instance.stopScan();
                }
              },
              children: const <Widget>[ScannerList()],
            ),
            const SizedBox(height: 20),
            // testing only
            const AppLogo(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomButton(
                onPressed: () {},
                icon: const Icon(Icons.person_rounded, size: 30),
                child: Text(
                  AppStateScope.of(context).currentUser!.id,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SwitchListTile.adaptive(
              activeColor: googleGreen,
              title: const Text('Automatic data upload'),
              value: AppStateScope.of(context).settingsState!.autoUpload!,
              onChanged: (bool value) => setState(() => AppStateScope.of(context).settingsState!.autoUpload = value),
              subtitle: const Text(
                'If device is connected to the internet, '
                'recorded data will be uploaded automatically.',
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile.adaptive(
              activeColor: googleGreen,
              title: const Text('Custom prescriptions'),
              value: AppStateScope.of(context).settingsState!.customPrescriptions!,
              onChanged: (bool value) => setState(() {
                AppStateScope.of(context).settingsState!.customPrescriptions = value;
                AppStateScope.of(context).togglePrescription();
              }),
              subtitle: const Text(
                'Disable it to user prescriptions provided by '
                'your clinician for MVC Test and Exercise Mode.',
              ),
            ),
            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField(
                controller: _ctrlGraphSize,
                pattern: r'^\d{1,3}(\.\d{0,2})?',
                label: 'Graph Y-Axis max size (default: 30 Kg)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              trailing: CustomButton(
                child: Text(
                  localDataCount.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: red400),
                ),
              ),
              title: const Text('Export locallly stored data'),
              onTap: () async {
                if (localDataCount > 0) {
                  await Future<void>.microtask(() => tryUpload(context));
                  AppStateWidget.of(context).refresh();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No data available! or already submitted.'),
                  ));
                }
              },
            ),
            const Divider(thickness: 2),
            ListTile(title: const Text('About'), onTap: () => aboutDialog(context)),
            const Divider(thickness: 2),
            ListTile(
              title: const Text('Logout', style: TextStyle(color: red400)),
              onTap: () async {
                await signOut();
                AppStateScope.of(context).userState!.keepSigned = false;
                await AppStateScope.of(context).userState!.save();
                await AppStateScope.of(context).settingsState!.save();
                await Navigator.pushReplacementNamed(context, Login.route);
              },
            ),
          ]),
        ),
      ),
    );
  }
}

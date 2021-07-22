import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/utils/textstyles.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/screens/device/scanner_list.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/handlers/auth_handler.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/helper.dart';
import 'package:tendon_loader/handlers/splash_handler.dart';
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
    if (boxExport.isNotEmpty) {
      await tryUpload(context).then((_) => context.view.refresh);
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
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: AppFrame(
          onExit: () => context.model.settingsState!.save().then((_) => true),
          child: Column(children: <Widget>[
            // testing only ----------------------
            SwitchListTile.adaptive(
              value: isSumulation,
              tileColor: Colors.red,
              activeColor: colorGoogleGreen,
              title: const Text('Use without progressor', style: TextStyle(color: Colors.white, fontSize: 20)),
              onChanged: (bool value) => setState(() => isSumulation = value),
              subtitle: const Text(
                'Use app without the progressor, generate and submit fake data '
                'for MVC and Exercise Mode, testing perpose only!',
                style: TextStyle(color: Colors.white),
              ),
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
            // testing only end -----------------------
            const AppLogo(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: FittedBox(
                child: CustomButton(
                  icon: const Icon(Icons.person_rounded, size: 30),
                  child: Text(
                    context.model.currentUser!.id,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SwitchListTile.adaptive(
              activeColor: colorGoogleGreen,
              title: const Text('Automatic data upload'),
              value: context.model.settingsState!.autoUpload!,
              onChanged: (bool value) => setState(() => context.model.settingsState!.autoUpload = value),
              subtitle: const Text(
                'If device is connected to the internet, '
                'recorded data will be uploaded automatically.',
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile.adaptive(
              activeColor: colorGoogleGreen,
              title: const Text('Custom prescriptions'),
              value: context.model.settingsState!.customPrescriptions!,
              onChanged: (bool value) => setState(() {
                context.model.settingsState!.customPrescriptions = value;
                context.model.togglePrescription();
              }),
              subtitle: const Text(
                'Disable it to user prescriptions provided by your '
                'clinician for MVC Test and Exercise Mode.',
              ),
            ),
            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CustomTextField(
                controller: _ctrlGraphSize,
                pattern: r'^\d{1,3}(\.\d{0,2})?',
                label: 'Y-Axis Size (default: 30 Kg)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            ListTile(
              title: const Text('Press the button to export locallly stored data'),
              trailing: CustomButton(
                onPressed: _tryUpload,
                child: Text(boxExport.length.toString(), style: tsG24BFF),
              ),
            ),
            const Divider(thickness: 2),
            ListTile(title: const Text('About'), onTap: () => about(context)),
            const Divider(thickness: 2),
            ListTile(onTap: _logout, title: const Text('Logout', style: TextStyle(color: colorRed400))),
          ]),
        ),
      ),
    );
  }
}

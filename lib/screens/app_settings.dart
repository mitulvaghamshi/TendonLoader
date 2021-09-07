/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/bluetooth/device_handler.dart';
import 'package:tendon_loader/custom/about_tile.dart';
import 'package:tendon_loader/custom/app_frame.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_tile.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/routes.dart';
import 'package:tendon_loader/utils/themes.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  static const String route = '/userAppSettings';

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  late final TextEditingController _ctrlGraphScale = TextEditingController()
    ..text = settingsState.graphSize.toString();

  @override
  void dispose() {
    _ctrlGraphScale.dispose();
    super.dispose();
  }

  Future<void> _tryUpload() async {
    if (await tryUpload(context) ?? true) {
      setState(() {});
    } else {
      context.showSnackBar(
        const Text('No data available! or already submitted.'),
      );
    }
  }

  Future<bool> _onExit() async {
    final double? _scale = double.tryParse(_ctrlGraphScale.text);
    if (_scale != null && _scale > 0) {
      settingsState.graphSize = _scale;
    }
    await settingsState.save();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _buildBody() : _buildScaffold();
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      child: AppFrame(
        onExit: _onExit,
        child: Column(children: <Widget>[
          CustomTile(
            title: patient.id,
            left: const Icon(Icons.person, color: colorIconBlue),
          ),
          const Divider(),
          if (!kIsWeb) ...<Widget>[
            SwitchListTile.adaptive(
              activeColor: colorIconBlue,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              value: settingsState.autoUpload!,
              title: const Text('Automatic data upload'),
              subtitle: const Text(
                'Automatically upload exercise '
                'and mvc test data on completion.',
              ),
              onChanged: (bool value) => setState(() {
                settingsState.autoUpload = value;
              }),
            ),
            SwitchListTile.adaptive(
              activeColor: colorIconBlue,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              title: const Text('Use custom prescriptions'),
              value: settingsState.customPrescriptions!,
              subtitle: const Text(
                'Provide your own prescriptions '
                'for exercise and mvc test.',
              ),
              onChanged: (bool value) => setState(() {
                settingsState.toggle(
                  value,
                  patient.prescription!,
                );
              }),
            ),
          ],
          SwitchListTile.adaptive(
            activeColor: colorIconBlue,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            title: const Text('Use dark mode'),
            subtitle: const Text(
              'Use dark interface '
              '(applied after app restart).',
            ),
            value: boxDarkMode.get(keyDarkModeBox, defaultValue: false)!,
            onChanged: (bool value) async {
              await boxDarkMode.put(keyDarkModeBox, value);
              setState(() {});
            },
          ),
          if (!kIsWeb) ...<Widget>[
            ListTile(
              onTap: _tryUpload,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              title: const Text('Locally stored data'),
              subtitle: const Text(
                'Click here to submit locally '
                'stored data to clinician.',
              ),
              trailing: CustomButton(
                rounded: true,
                left: Text(boxExport.length.toString(), style: ts22B),
              ),
            ),
            ListTile(
              title: const Text('Y-axis scale (default: 30kg)'),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              subtitle: const Text(
                'Consult your clinician before '
                'changing this value.',
              ),
              trailing: SizedBox(
                width: 60,
                child: TextField(
                  style: ts18w5,
                  controller: _ctrlGraphScale,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{1,2}(\.\d{0,2})?'),
                    ),
                  ],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
            ),
            if (progressor != null) ...<Widget>[
              ListTile(
                title: Text(
                  'Disconnect ($deviceName)',
                  style: const TextStyle(color: colorErrorRed),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                subtitle: const Text('Long press to sleep the progressor'),
                onTap: () async {
                  await disconnectDevice().then((_) => setState(() {}));
                },
                onLongPress: () async => disconnectDevice(sleep: true).then(
                  (_) => setState(() {}),
                ),
              ),
            ],
          ],
          const AboutTile(),
          ListTile(
            onTap: () async => logout(context),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: const Text(
              'Logout',
              style: TextStyle(color: colorErrorRed),
            ),
          ),
        ]),
      ),
    );
  }
}

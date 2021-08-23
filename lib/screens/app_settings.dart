import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/bluetooth/device_handler.dart';
import 'package:tendon_loader/custom/about_tile.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/constants.dart';
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
      context.showSnackBar(
        const Text('No data available! or already submitted.'),
      );
    }
  }

  Future<bool> _onExit() async {
    final double? scale = double.tryParse(_ctrlGraphScale.text);
    if (scale != null && scale > 0) context.settingsState.graphSize = scale;
    return context.settingsState.save().then((_) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: kIsWeb
          ? Center(child: SizedBox(width: 500, child: _buildBody()))
          : _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Consult your clinician before '
                'modifying the axis scale value.',
              ),
            ]),
          ),
          const Divider(),
          SwitchListTile.adaptive(
            activeColor: colorBlue,
            value: context.settingsState.autoUpload!,
            title: const Text('Automatic data upload'),
            subtitle: const Text(
              'Automatically upload exercise '
              'and mvc test data on completion.',
            ),
            onChanged: (bool value) {
              setState(() => context.settingsState.autoUpload = value);
            },
          ),
          const Divider(),
          SwitchListTile.adaptive(
            activeColor: colorBlue,
            title: const Text('Use custom prescriptions'),
            value: context.settingsState.customPrescriptions!,
            subtitle: const Text(
              'Provide your own prescriptions '
              'for exercise and mvc test.',
            ),
            onChanged: (bool value) => setState(() {
              context.settingsState.toggleCustom(value, context.patient);
            }),
          ),
          const Divider(),
          SwitchListTile.adaptive(
            activeColor: colorBlue,
            title: const Text('Use dark mode'),
            subtitle: const Text('Use dark theme (restart required).'),
            value: boxDarkMode.get(keyDarkModeBox, defaultValue: false)!,
            onChanged: (bool value) async {
              await boxDarkMode.put(keyDarkModeBox, value);
              setState(() {});
            },
          ),
          const Divider(),
          ListTile(
            onTap: _tryUpload,
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
          if (progressor != null) ...<Widget>[
            const Divider(),
            ListTile(
              title: Text('Disconnect ($deviceName)'),
              subtitle: const Text('Long pres to sleep progressor'),
              onTap: () async {
                await disconnectDevice().then((_) => setState(() {}));
              },
              onLongPress: () async {
                await disconnectDevice(sleep: true).then((_) {
                  setState(() {});
                });
              },
            ),
          ],
          const Divider(),
          const AboutTile(),
          const Divider(),
          ListTile(
            onTap: () async => logout(context),
            title: const Text(
              'Logout',
              style: TextStyle(color: colorRed400),
            ),
          ),
        ]),
      ),
    );
  }
}

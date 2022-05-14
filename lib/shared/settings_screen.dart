import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tendon_loader/app/bluetooth/bluetooth_handler.dart';
import 'package:tendon_loader/shared/utils/common.dart';
import 'package:tendon_loader/shared/utils/constants.dart';
import 'package:tendon_loader/shared/utils/routes.dart';
import 'package:tendon_loader/shared/widgets/alert_widget.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';
import 'package:tendon_loader/shared/widgets/frame_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const String route = '/settings';

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _ctrlGraphScale = TextEditingController()
    ..text = settingsState.graphSize.toString();

  @override
  void dispose() {
    _ctrlGraphScale.dispose();
    super.dispose();
  }

  Future<void> _tryUpload() async {
    if (await tryUpload() == 0) return;
    setState(() {});
    await AlertWidget.show<void>(
      context,
      title: 'Upload success!!!',
      content: const Text(
        'Data submitted successfully!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Color(0xff3ddc85),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<bool> _onExit() async {
    final double? scale = double.tryParse(_ctrlGraphScale.text);
    if (scale != null && scale > 0) {
      settingsState.graphSize = scale;
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
      appBar: AppBar(
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      child: FrameWidget(
        onExit: _onExit,
        child: Column(children: <Widget>[
          ListTile(
            title: Text(
              patient.id,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            contentPadding: const EdgeInsets.all(16),
            leading: const ButtonWidget(
              left: Icon(Icons.person),
              padding: EdgeInsets.zero,
            ),
          ),
          const Divider(thickness: 2, height: 0),
          if (!kIsWeb) ...<Widget>[
            SwitchListTile.adaptive(
              title: const Text('Automatic data upload'),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              subtitle: const Text(
                'Automatically upload exercise '
                'and mvc test data on completion.',
              ),
              value: settingsState.autoUpload!,
              onChanged: (bool value) => setState(() {
                settingsState.autoUpload = value;
              }),
            ),
            SwitchListTile.adaptive(
              title: const Text('Use custom prescriptions'),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              subtitle: const Text(
                'Provide your own prescriptions '
                'for exercise and mvc test.',
              ),
              value: settingsState.customPrescriptions!,
              onChanged: (bool value) => setState(() {
                settingsState.toggle(value, patient.prescription!);
              }),
            ),
          ],
          SwitchListTile.adaptive(
            title: const Text('Use dark mode'),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
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
              enabled: boxExport.isNotEmpty,
              title: const Text('Locally stored data'),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              subtitle: const Text(
                'Click here to submit locally '
                'stored data to clinician.',
              ),
              trailing: ButtonWidget(
                left: Text(
                  boxExport.length.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
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
                  style: const TextStyle(color: Color(0xffff534d)),
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
          AboutListTile(
            applicationVersion: 'v1.0.0',
            applicationName: 'Tendon Loader',
            applicationIcon: SvgPicture.asset(imgAppLogo, height: 100),
            applicationLegalese: 'Please see the license for copyright notice.',
            aboutBoxChildren: const <Widget>[
              Divider(thickness: 2),
              Text(
                'Tendon Loader is a project designed to measure '
                'and help overcome the Achilles Tendon Problems.',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Text('Contact us:\n', style: TextStyle(fontSize: 12)),
            ],
            child: const Text('About'),
          ),
          ListTile(
            onTap: () async => logout(context),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: const Text('Logout',
                style: TextStyle(color: Color(0xffff534d))),
          ),
        ]),
      ),
    );
  }
}

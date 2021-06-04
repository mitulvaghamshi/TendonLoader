import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/handler/app_auth.dart';
import 'package:tendon_loader/handler/user.dart';
import 'package:tendon_loader/screens/login.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  static const String route = '/settings';

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  final Box<Map<dynamic, dynamic>> _settingsBox = Hive.box(keyAppSettingsBox);
  late final Map<String, dynamic> _settings;

  late bool _autoUpload;
  late bool _editableExercise;

  @override
  void initState() {
    super.initState();
    getSettings();
  }

  @override
  void dispose() {
    setSettings();
    super.dispose();
  }

  // todo(me): move hard-coded key to Keys mixin (constants.dart)
  Future<void> getSettings() async {
    if (_settingsBox.containsKey(keyAppSettingsBox)) {
      _settings = Map<String, dynamic>.from(_settingsBox.get(keyAppSettingsBox)!);
      _autoUpload = _settings['_key_auto_upload'] as bool? ?? false;
      _editableExercise = _settings['_key_exercise_editable'] as bool? ?? false;
    } else {
      _settings = <String, dynamic>{};
      context.read<User>().autoUpload = _autoUpload = false;
      context.read<User>().editableExercise = _editableExercise = false;
    }
  }

  Future<void> setSettings() async {
    _settings['_key_auto_upload'] = _autoUpload;
    _settings['_key_exercise_editable'] = _editableExercise;
    await _settingsBox.put(keyAppSettingsBox, _settings);
  }

  @override
  Widget build(BuildContext context) {
    context.read<User>().autoUpload = _autoUpload;
    context.read<User>().editableExercise = _editableExercise;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: AppFrame(
          child: Column(children: <Widget>[
            FittedBox(
              child: Row(
                children: <Widget>[
                  const AppLogo(size: 70),
                  const SizedBox(width: 20),
                  Text(
                    context.read<User>().userId!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _autoUpload,
              title: const Text('Automatic data upload'),
              onChanged: (bool value) => setState(() => _autoUpload = value),
              subtitle: const Text(
                'If device is connected to the internet, data is transfered to the cloud right away. '
                'Or, data stored locally, and auto uploaded on launch.',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.justify,
              ),
            ),
            SwitchListTile(
              value: _editableExercise,
              title: const Text('Editable exercise mode *UNDER PROCESS'),
              // onChanged: (bool value) => setState(() => _editableExercise = value),
              onChanged: (bool value) {},
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

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tendon_support_lib/tendon_support_lib.dart';
import 'package:tendon_support_module/app_auth.dart';
import 'package:tendon_support_module/login/login.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  static const String route = '/settings';

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  bool _autoUpload = false;
  late final Map<String, dynamic> _settings;

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

  Future<void> getSettings() async {
    final Box<Map<dynamic, dynamic>> _settingsBox = Hive.box(Keys.keyAppSettingsBox);
    if (_settingsBox.containsKey(Keys.keyAppSettingsBox)) {
      _settings = Map<String, dynamic>.from(_settingsBox.get(Keys.keyAppSettingsBox)!);
      _autoUpload = _settings['_key_auto_upload'] as bool;
    } else {
      _settings = <String, dynamic>{};
    }
  }

  Future<void> setSettings() async {
    final Box<Map<dynamic, dynamic>> _settingsBox = Hive.box(Keys.keyAppSettingsBox);
    _settings['_key_auto_upload'] = _autoUpload;
    await _settingsBox.put(Keys.keyAppSettingsBox, _settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: AppFrame(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  const AppLogo(size: 70),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const <Widget>[
                      Text('Jane Doe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                      Text('Canada', style: TextStyle(color: Colors.grey)),
                    ]),
                  ),
                ],
              ),
            ),
            SwitchListTile(
              value: _autoUpload,
              title: const Text('Automatic data upload'),
              subtitle: const Text('Allows data upload without any user interaction...'),
              onChanged: (bool value) => setState(() => _autoUpload = value),
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

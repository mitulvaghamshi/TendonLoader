import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/widgets/custom_widget.dart';
import 'package:tendon_loader/common/widgets/image_widget.dart';
import 'package:tendon_loader/screens/bluetooth/models/bluetooth_handler.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';
import 'package:tendon_loader/screens/settings/models/settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with Progressor {
  late final AppState model = AppState.of(context);
  late final TextEditingController _scaleCtrl = TextEditingController()
    ..text = model.getGraphScale().toString();

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int length = model.getLocalExportLength();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: <Widget>[
          FloatingActionButton.extended(
            elevation: 0,
            heroTag: 'sign-out-tag',
            backgroundColor: Colors.transparent,
            icon: const Icon(Icons.logout),
            onPressed: FirebaseAuth.instance.signOut,
            label: const Text(
              'Sign out',
              style: TextStyle(
                color: Color(0xffff534d),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: FloatingActionButton.extended(
              onPressed: () {},
              heroTag: 'user-id-tag',
              icon: const Icon(Icons.person),
              label: Text(
                model.getCurrentUserId(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const Divider(thickness: 2, height: 0),
          SwitchListTile(
            contentPadding: Styles.tilePadding,
            title: const Text('Use dark mode'),
            subtitle: const Text('Use dark interface (restart required)'),
            value: model.isDarkMode(),
            onChanged: (bool value) => model.settings((Settings settings) {
              setState(() => settings.darkMode = value);
            }),
          ),
          SwitchListTile(
            contentPadding: Styles.tilePadding,
            title: const Text('Automatic data upload'),
            subtitle: const Text('Automatically upload data on completion'),
            value: model.isAutoUpload(),
            onChanged: (bool value) => model.settings((Settings settings) {
              setState(() => settings.autoUpload = value);
            }),
          ),
          SwitchListTile(
            contentPadding: Styles.tilePadding,
            title: const Text('Use custom prescriptions'),
            subtitle: const Text('Allows you to edit your prescriptions'),
            value: model.isCustomPrescriptions(),
            onChanged: (bool value) => model.settings((Settings settings) {
              setState(() => settings.customPrescriptions = value);
            }),
          ),
          ListTile(
            enabled: length > 0,
            contentPadding: Styles.tilePadding,
            title: const Text('Locally stored data'),
            subtitle: const Text('Click to safely backup data to cloud'),
            trailing: CustomWidget(child: Text(length.toString())),
            onTap: () async {
              final int count = await model.uploadExports();
              if (mounted) {
                setState(() {});
                ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                  content: Text(count == -1
                      ? 'No network connection.'
                      : 'Uploaded $count exports.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: ScaffoldMessenger.maybeOf(context)
                          ?.clearMaterialBanners,
                      child: const Text('Dismiss'),
                    )
                  ],
                ));
              }
            },
          ),
          ListTile(
            contentPadding: Styles.tilePadding,
            title: const Text('Y-axis scale (default: 30kg)'),
            subtitle: const Text('Maximum visible weight on the graph'),
            trailing: SizedBox(
              width: 60,
              child: TextField(
                style: Styles.titleStyle,
                controller: _scaleCtrl,
                onChanged: (String value) => model.settings(
                    (Settings settings) => setState(() =>
                        settings.graphScale = double.tryParse(value) ?? 30.0)),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{1,2}(\.\d{0,2})?'),
                  ),
                ],
              ),
            ),
          ),
          if (progressor != null)
            ListTile(
              contentPadding: Styles.tilePadding,
              title: Text(
                'Disconnect ($progressorName)',
                style: const TextStyle(color: Color(0xffff534d)),
              ),
              subtitle: const Text('Long press to sleep the progressor'),
              onTap: () => setState(() async => disconnect()),
              onLongPress: () => setState(() => disconnect(sleep: true)),
            ),
          const AboutListTile(
            applicationVersion: 'v1.0.0',
            applicationName: 'Tendon Loader',
            applicationLegalese: 'Copyright 2023, Mitul Vaghamshi.',
            applicationIcon: ImageWidget(maxSize: 50, padding: EdgeInsets.zero),
            aboutBoxChildren: <Widget>[
              Divider(thickness: 2),
              Text(
                'Tendon Loader is designed to measure and help cure '
                'Achille\'s (uh-KILL-eez) Tendon Problems.',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Text('Contact us:'),
              ),
              Text(
                'Email: mitulvaghmashi@gmail.com',
                style: TextStyle(fontSize: 12),
              ),
            ],
            child: Text('About'),
          ),
        ]),
      ),
    );
  }
}

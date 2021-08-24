import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/about_tile.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_textfield.dart';
import 'package:tendon_loader/custom/custom_tile.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/utils/validator.dart';
import 'package:tendon_loader/web/user_list.dart';

class WebSettings extends StatefulWidget {
  const WebSettings({Key? key}) : super(key: key);

  static const String route = '/userWebSettings';

  @override
  _WebSettingsState createState() => _WebSettingsState();
}

class _WebSettingsState extends State<WebSettings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _isAdmin = false;

  Future<bool> _onExit() async {
    return context.settingsState.save().then((_) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppFrame(
              child: SizedBox(
                width: 350,
                child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    const CustomTile(
                      title: 'Create new user',
                      left: Icon(Icons.add, color: colorBlue),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: 'Username',
                      controller: _emailCtrl,
                      validator: validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                      label: 'Password',
                      validator: validatePass,
                      controller: _passwordCtrl,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile.adaptive(
                      value: _isAdmin,
                      activeColor: colorBlue,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Allow web portal access'),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (_) => setState(() => _isAdmin = !_isAdmin),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CustomButton(
                        onPressed: () {},
                        left: const Icon(Icons.add),
                        right: const Text('Add patient'),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            AppFrame(
              onExit: _onExit,
              child: SizedBox(
                width: 350,
                child: Column(children: <Widget>[
                  CustomTile(
                    title: context.patient.id,
                    left: const Icon(Icons.person, color: colorBlue),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile.adaptive(
                    activeColor: colorBlue,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    title: const Text('Use dark mode'),
                    subtitle: const Text(
                      'Use dark interface '
                      '(applied after app restart).',
                    ),
                    value:
                        boxDarkMode.get(keyDarkModeBox, defaultValue: false)!,
                    onChanged: (bool value) async {
                      await boxDarkMode.put(keyDarkModeBox, value);
                      setState(() {});
                    },
                  ),
                  const AboutTile(),
                  ListTile(
                    onTap: () async => logout(context),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: colorRed400),
                    ),
                  ),
                ]),
              ),
            ),
            SizedBox(
              width: 350,
              height: 500,
              child: UserList(),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

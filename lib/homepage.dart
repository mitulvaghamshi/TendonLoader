import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/login/app_auth.dart';
import 'package:tendon_loader/login/login.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/web_portal/left_panel.dart';
import 'package:tendon_loader/web_portal/right_panel.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/homePage';
  static const String name = 'Tendon Loader - Clinician';

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Access!!!, Please Login...')));
      Navigator.pushReplacementNamed(context, Login.route);
    }

    final AppBar _appBar = AppBar(title: const Text(name), actions: <Widget>[
      CustomButton(
        reverce: true,
        onPressed: () async {
          await signOut();
          await Navigator.pushReplacementNamed(context, Login.route);
        },
        icon: const Icon(Icons.logout, color: colorRed400),
        child: const Text('Logout', style: TextStyle(color: colorRed400)),
      ),
    ]);

    if (MediaQuery.of(context).size.width > 960) {
      return Scaffold(
        appBar: _appBar,
        body: Row(children: const <Widget>[LeftPanel(), Expanded(child: RightPanel())]),
      );
    } else {
      return Scaffold(appBar: _appBar, drawer: const LeftPanel(), body: const RightPanel());
    }
  }
}

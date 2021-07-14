import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/login/login.dart';
import 'package:tendon_loader/utils/app_auth.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/web_portal/left_panel.dart';
import 'package:tendon_loader/web_portal/right_panel.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/homePage';
  static const String name = 'Tendon Loader - Clinician';

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      context.showSnackBar(const Text('Invalid Access!!!, Please Login...'));
      context.push(Login.route, replace: true);
    }
    final bool _isWide = MediaQuery.of(context).size.width > 960;
    return Scaffold(
      appBar: AppBar(title: const Text(name), actions: <Widget>[
        CustomButton(
          radius: 16,
          reverce: true,
          icon: const Icon(Icons.logout),
          onPressed: () async => firebaseLogout().then((_) async => context.push(Login.route, replace: true)),
          child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ]),
      drawer: _isWide ? null : const LeftPanel(),
      body: _isWide ? Row(children: const <Widget>[LeftPanel(), Expanded(child: RightPanel())]) : const RightPanel(),
    );
  }
}

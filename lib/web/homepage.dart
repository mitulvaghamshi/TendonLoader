import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/screens/app_settings.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/web/data_view.dart';
import 'package:tendon_loader/web/lists/export_list.dart';
import 'package:tendon_loader/web/lists/user_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/homePage';
  static const String name = 'Tendon Loader - Clinician';

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushAndRemoveUntil<void>(
        buildRoute(Login.route),
        (_) => false,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(name),
        centerTitle: true,
        actions: <Widget>[
          CustomButton(
            left: const Icon(Icons.add),
            right: const Text('Create user'),
            onPressed: () async => CustomDialog.show<void>(
              context,
              content: const Login(isRegister: true),
            ),
          ),
          const SizedBox(width: 10),
          CustomButton(
            left: const Icon(Icons.settings),
            right: const Text('Settings'),
            onPressed: () async => CustomDialog.show<void>(
              context,
              content: const AppSettings(),
            ),
          ),
        ],
      ),
      body: Row(children: const <Widget>[
        UserList(),
        ExportList(),
        Expanded(child: DataView()),
      ]),
    );
  }
}

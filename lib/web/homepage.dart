import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/web/common.dart';
import 'package:tendon_loader/web/data_list.dart';
import 'package:tendon_loader/web/data_view.dart';
import 'package:tendon_loader/web/session_info.dart';
import 'package:tendon_loader/web/user_list.dart';
import 'package:tendon_loader/web/web_settings.dart';



class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/homePage';
  static const String name = 'Tendon Loader - Clinician';

  Future<void> _sessionInfo(BuildContext context) async {
    return CustomDialog.show<void>(
      context,
      title: 'Session Info',
      content: const SessionInfo(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushAndRemoveUntil<void>(
        context,
        buildRoute(Login.route),
        (_) => false,
      );
    }
    final bool _isWide = MediaQuery.of(context).size.width > 1080;
    // final bool _isMedium = MediaQuery.of(context).size.width > 760;

    return Scaffold(
      appBar: AppBar(title: const Text(name), actions: <Widget>[
        if (!_isWide && clickNotifier.value != null)
          CustomButton(
            left: const Icon(Icons.info),
            right: const Text('Session Info'),
            onPressed: () => _sessionInfo(context),
          ),
        const SizedBox(width: 5),
        CustomButton(
          radius: 8,
          left: const Text('Settings'),
          right: const Icon(Icons.settings),
          onPressed: () async => context.push(WebSettings.route),
        ),
      ]),
      body: _isWide ? const _WideScreen() : const DataView(),
      drawer: _isWide ? null : const Drawer(child: UserList()),
    );
  }
}

class _WideScreen extends StatelessWidget {
  const _WideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: const <Widget>[
      UserList(),
      CenterPanel(),
      Expanded(child: DataView())
    ]);
  }
}

class CenterPanel extends StatelessWidget {
  const CenterPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: 250,
        child: Column(children: const <Widget>[
          SessionInfo(),
          Expanded(child: DataList())
        ]),
      ),
    );
  }
}

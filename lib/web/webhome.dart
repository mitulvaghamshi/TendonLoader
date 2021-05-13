import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/app_auth.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';
import 'package:tendon_loader/shared/login/login.dart';
import 'package:tendon_loader/web/panel/left_panel.dart';
import 'package:tendon_loader/web/panel/right_panel.dart';

class WebHome extends StatelessWidget {
  const WebHome({Key key}) : super(key: key);

  static const String name = 'Tendon Loader - Clinician';

  @override
  Widget build(BuildContext context) {
    // if (AppAuth.user() == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session timed out, please login again!!!')));
    //   Navigator.pushReplacementNamed(context, Login.route);
    // }
    final Size _size = MediaQuery.of(context).size;
    final bool _isTab = _size <= const Size(1000, 800) || _size.aspectRatio <= 1.0;
    final bool _isSmall = _size.width < 500 || _size.height < 500;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(WebHome.name),
        actions: <Widget>[
          CustomButton(
            text: 'Logout',
            icon: Icons.logout,
            onPressed: () {
              AppAuth.signOut();
              Navigator.pushReplacementNamed(context, Login.route);
            },
          ),
        ],
      ),
      drawer: _isTab ? const Drawer(child: LeftPanel()) : null,
      body: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          if (_isSmall) {
            return const Center(child: Text(':) Unsupported window size!'));
          } else if (_isTab) {
            return const RightPanel();
          }
          return Row(children: const <Widget>[
            LimitedBox(maxWidth: Sizes.SIZE_LEFT_PANEL, child: LeftPanel()),
            Expanded(child: RightPanel()),
          ]);
        },
      ),
    );
  }
}

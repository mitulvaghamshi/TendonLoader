import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/app_auth.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';
import 'package:tendon_loader/web/line_graph.dart';
import 'package:tendon_loader/web/panel/left_panel.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  static const String route = '/homePage';

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tendon Loader - Clinician'),
        actions: <Widget>[CustomButton(text: 'Logout', icon: Icons.logout, onPressed: () => AppAuth.signOut(context))],
      ),
      drawer: _size.width < _size.height ? const Drawer(child: LeftPanel()) : null,
      body: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          // if (AppAuth.user() == null) {
          //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session timed out, please login again!!!')));
          //   Navigator.pushReplacementNamed(context, Login.route);
          // }
          return constraints.isSatisfiedBy(const Size.fromRadius(150))
              ? _size.height < _size.width - 56
                  ? Row(children: const <Widget>[
                      LimitedBox(maxWidth: Sizes.SIZE_MOBILE, child: LeftPanel()),
                      Expanded(child: LineGraph()),
                    ])
                  : const LineGraph()
              : const Center(child: Text('Unsupported window size!'));
        },
      ),
    );
  }
}

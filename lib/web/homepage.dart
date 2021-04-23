import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/app_auth.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';
import 'package:tendon_loader/web/panel/left_panel.dart';
import 'package:tendon_loader/web/panel/right_panel.dart';

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
      drawer: _size.width > _size.height ? null : const Drawer(child: LeftPanel()),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (!constraints.isSatisfiedBy(const Size.fromRadius(150))) {
            return const Center(child: Text('Unsupported window size!'));
          }
          if (_size.height > _size.width - 56) {
            return const RightPanel();
          } else {
            return Row(children: const <Widget>[
              LimitedBox(maxWidth: Sizes.SIZE_MOBILE, child: LeftPanel()),
              Expanded(child: RightPanel())
            ]);
          }
        },
      ),
    );
  }
}

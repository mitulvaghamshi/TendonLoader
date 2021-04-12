import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/portal/left_panel.dart';
import 'package:tendon_loader/portal/right_panel.dart';
import 'package:tendon_loader/utils/app/constants.dart';
import 'package:tendon_loader/utils/cloud/app_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  static const String route = '/homePage';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tendon Loader - Admin'),
        actions: <Widget>[CustomButton(text: 'Logout', icon: Icons.logout, onPressed: () => AppAuth.signOut(context))],
      ),
      drawer: size.width > size.height ? null : const Drawer(child: LeftPanel()),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (!constraints.isSatisfiedBy(const Size.fromRadius(150))) return const Center(child: Text('Unsupported window size!'));
          if (size.height > size.width - 56) {
            return const RightPanel();
          } else {
            return Row(children: const <Widget>[LimitedBox(maxWidth: Sizes.sizeMobile, child: LeftPanel()), Expanded(child: RightPanel())]);
          }
        },
      ),
    );
  }
}

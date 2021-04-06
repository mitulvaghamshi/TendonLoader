import 'package:flutter/material.dart';
<<<<<<< Updated upstream:lib/webportal/homepage.dart
import 'package:tendon_loader/screens/home.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/webportal/content.dart';
import 'package:tendon_loader/webportal/aside_bar.dart';
=======
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/portal/left_panel.dart';
import 'package:tendon_loader/portal/right_panel.dart';
import 'package:tendon_loader/utils/app_auth.dart';
import 'package:tendon_loader/utils/constants.dart';
>>>>>>> Stashed changes:lib/portal/homepage.dart

class HomePage extends StatelessWidget {
  const HomePage({Key/*?*/ key}) : super(key: key);

  static const String routeName = '/homePage';

  @override
  Widget build(BuildContext context) {
    final double _mWidth = MediaQuery.of(context).size.width;
    final bool _mIsWeb = _mWidth < SizeFactor.sizeWeb;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
<<<<<<< Updated upstream:lib/webportal/homepage.dart
        title: const Text('Tendon Loader - Admin',),
        actions: [
          PopupMenuButton<ActionType>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (ActionType type) {},
            itemBuilder: (BuildContext context) => <PopupMenuItem<ActionType>>[
              const PopupMenuItem<ActionType>(value: ActionType.settings, child: Text('Settings')),
              const PopupMenuItem<ActionType>(value: ActionType.export, child: Text('Export')),
              const PopupMenuItem<ActionType>(value: ActionType.about, child: Text('About')),
              if (true) const PopupMenuItem<ActionType>(value: ActionType.close, child: Text('Exit')),
            ],
          ),
        ],
      ),
      drawer: _mIsWeb ? const Drawer(child: AsideBar()) : null,
      body: SafeArea(
        child: _mIsWeb
            ? const Content()
            : Row(
                children: <SizedBox>[
                  const SizedBox(width: SizeFactor.sizeAside, child: AsideBar()),
                  SizedBox(width: _mWidth - SizeFactor.sizeAside, child: const Content()),
                ],
              ),
=======
        title: const Text('Tendon Loader - Admin'),
        actions: <Widget>[CustomButton(text: 'Logout', icon: Icons.logout, onPressed: () => AppAuth.signOut(context))],
      ),
      drawer: size.width > size.height ? null : const Drawer(child: LeftPanel()),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size size = constraints.biggest;
          if (size.height > size.width - 56) {
            return const RightPanel();
          } else {
            return Row(children: const <Widget>[LimitedBox(maxWidth: Sizes.sizeMobile, child: LeftPanel()), Expanded(child: RightPanel())]);
          }
        },
>>>>>>> Stashed changes:lib/portal/homepage.dart
      ),
    );
  }
}

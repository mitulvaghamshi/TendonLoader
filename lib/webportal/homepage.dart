import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/home.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/webportal/content.dart';
import 'package:tendon_loader/webportal/aside_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  static const String routeName = '/homePage';

  @override
  Widget build(BuildContext context) {
    final double _mWidth = MediaQuery.of(context).size.width;
    final bool _mIsWeb = _mWidth < SizeFactor.sizeWeb;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
      ),
    );
  }
}

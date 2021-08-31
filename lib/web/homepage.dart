import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/screens/app_settings.dart';
import 'package:tendon_loader/screens/homescreen.dart';
import 'package:tendon_loader/screens/login.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/web/panels/data_list.dart';
import 'package:tendon_loader/web/panels/data_view.dart';
import 'package:tendon_loader/web/panels/export_list.dart';
import 'package:tendon_loader/web/panels/user_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/homePage';
  static const String name = 'Tendon Loader - Clinician';

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) context.logout();
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      if (constraints.smallest >= sizeWideScreen) {
        return const _WideLayout();
      } else if (constraints.smallest >= sizeMediumScreen) {
        return const _MediumLayout();
      } else if (constraints.smallest >= sizeSmallScreen) {
        return const _SmallLayout();
      } else if (constraints.smallest >= sizeTinyScreen) {
        return const _TinyLayout();
      } else {
        return const Center(child: CustomImage());
      }
    });
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: Row(children: const <Widget>[
        UserList(),
        ExportList(),
        DataList(),
        Expanded(child: DataView()),
      ]),
    );
  }
}

class _MediumLayout extends StatelessWidget {
  const _MediumLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: Row(children: const <Widget>[
        _DrawerLayout(),
        DataList(),
        Expanded(child: DataView()),
      ]),
    );
  }
}

class _SmallLayout extends StatelessWidget {
  const _SmallLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(withText: false),
      drawer: const _DrawerLayout(),
      body: Row(children: const <Widget>[
        DataList(),
        Expanded(child: DataView()),
      ]),
    );
  }
}

class _TinyLayout extends StatelessWidget {
  const _TinyLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(withText: false),
      drawer: const _DrawerLayout(),
      body: Column(children: const <Widget>[
        Expanded(child: DataList()),
        Expanded(child: DataView()),
      ]),
    );
  }
}

class _DrawerLayout extends StatelessWidget {
  const _DrawerLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: const <Widget>[
      Expanded(child: UserList()),
      Expanded(child: ExportList()),
    ]);
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({Key? key, this.withText = true}) : super(key: key);

  final bool withText;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(HomeScreen.name),
      centerTitle: true,
      actions: <Widget>[
        CustomButton(
          rounded: !withText,
          left: const Icon(Icons.add),
          right: withText ? const Text('Create user') : null,
          onPressed: () async => CustomDialog.show<void>(
            context,
            title: 'Create new user',
            content: const Login(isRegister: true),
          ),
        ),
        const SizedBox(width: 10),
        CustomButton(
          rounded: !withText,
          left: const Icon(Icons.settings),
          right: withText ? const Text('Settings') : null,
          onPressed: () async => CustomDialog.show<void>(
            context,
            title: 'Settings',
            size: const Size(350, 400),
            content: const AppSettings(),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(54);
}

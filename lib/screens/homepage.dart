import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/handlers/auth_handler.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/screens/web/left_panel/user_list.dart';
import 'package:tendon_loader/screens/web/right_panel/data_list.dart';
import 'package:tendon_loader/screens/web/right_panel/data_view.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

final ValueNotifier<Export?> clickNotifier = ValueNotifier<Export?>(null);

enum PopupAction { download, delete, prescribe }

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/homePage';
  static const String name = 'Tendon Loader - Clinician';

  @override
  Widget build(BuildContext context) {
    // if (currentUser == null) context.push(Login.route, replace: true);
    final bool _isWide = MediaQuery.of(context).size.width > 960;

    return Scaffold(
      appBar: AppBar(title: const Text(name), actions: <Widget>[
        CustomButton(
          radius: 8,
          right: const Icon(Icons.logout),
          left: const Text('Logout', style: ts18BFF),
          onPressed: () async => firebaseLogout().then((_) async => context.push(Login.route, replace: true)),
        ),
      ]),
      body: _isWide ? const _WideScreen() : const DataView(),
      drawer: _isWide ? null : Container(width: 350, color: colorDark1, child: const UserList()),
    );
  }
}

class _WideScreen extends StatelessWidget {
  const _WideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: const <Widget>[
      SizedBox(width: 350, child: UserList()),
      VerticalDivider(),
      SizedBox(width: 250, child: DataList()),
      VerticalDivider(),
      Expanded(child: DataView()),
    ]);
  }
}

Future<void> confirmDelete(BuildContext context, VoidCallback onDelete) async {
  return showDialog<void>(
    context: context,
    builder: (_) => CustomDialog(
      title: 'Delete export(s)?',
      content: CustomButton(
        onPressed: () {
          onDelete();
          context.view.refresh();
          context.pop();
        },
        radius: 8,
        color: colorRed900,
        left: const Icon(Icons.delete, color: colorWhite),
        right: const Text('Permanently delete', style: TextStyle(color: colorWhite)),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/webportal/data_list.dart';
import 'package:tendon_loader/webportal/data_view.dart';
import 'package:tendon_loader/webportal/session_info.dart';
import 'package:tendon_loader/webportal/user_list.dart';

final ValueNotifier<Export?> clickNotifier = ValueNotifier<Export?>(null);

enum PopupAction { isClinician, download, delete, prescribe, history }

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/homePage';
  static const String name = 'Tendon Loader - Clinician';

  Future<void> _sessionInfo(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => const CustomDialog(title: 'Session Info', content: SessionInfo()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (currentUser == null) context.push(Login.route, replace: true);
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
          radius: 16,
          left: const Text('Logout'),
          right: const Icon(Icons.logout),
          onPressed: () async => logout(context),
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
    return Row(children: const <Widget>[UserList(), CenterPanel(), Expanded(child: DataView())]);
  }
}

class CenterPanel extends StatelessWidget {
  const CenterPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: 260,
        child: Column(children: const <Widget>[SessionInfo(), Expanded(child: DataList())]),
      ),
    );
  }
}

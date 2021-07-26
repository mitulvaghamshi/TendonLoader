import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/handlers/auth_handler.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/screens/web/left_panel/left_panel.dart';
import 'package:tendon_loader/screens/web/right_panel/right_panel.dart';
import 'package:tendon_loader/utils/extension.dart';

final BehaviorSubject<Export> _clickCtrl = BehaviorSubject<Export>();

Stream<Export> get selectedItemStream => _clickCtrl.stream;

Sink<Export> get selectedItemSink => _clickCtrl.sink;

void disposeSelectedItem() {
  if (!_clickCtrl.isClosed) _clickCtrl.close();
}

final ValueNotifier<Export?> onSelect = ValueNotifier<Export?>(null);

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/homePage';
  static const String name = 'Tendon Loader - Clinician';

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) context.push(Login.route, replace: true);
    final bool _isWide = MediaQuery.of(context).size.width > 960;
    return Scaffold(
      appBar: AppBar(title: const Text(name), actions: <Widget>[
        CustomButton(
          radius: 16,
          reverce: true,
          icon: const Icon(Icons.logout),
          onPressed: () async => firebaseLogout().then((_) async => context.push(Login.route, replace: true)),
          child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ]),
      drawer: _isWide ? null : const LeftPanel(),
      body: _isWide ? Row(children: const <Widget>[LeftPanel(), Expanded(child: RightPanel())]) : const RightPanel(),
    );
  }
}

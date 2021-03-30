import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/webportal/left_panel.dart';
import 'package:tendon_loader/webportal/right_panel.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  static const String routeName = '/homePage';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Tendon Loader - Admin')),
      drawer: size.width > size.height ? null : const Drawer(child: LeftPanel()),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size size = constraints.biggest;
          if (size.height > size.width - 56) {
            return const RightPanel();
          } else {
            return Row(children: const <Widget>[LimitedBox(maxWidth: Sizes.mobileSize, child: LeftPanel()), Expanded(child: RightPanel())]);
          }
        },
      ),
    );
  }
}

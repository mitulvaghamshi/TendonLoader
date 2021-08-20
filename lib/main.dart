import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/themes.dart';

void main() => runApp(const AppStateWidget(child: TendonLoader()));

class TendonLoader extends StatelessWidget {
  const TendonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      title: 'Tendon Loader',
      initialRoute: Navigator.defaultRouteName,
      builder: (_, Widget? child) => CupertinoTheme(
        data: const CupertinoThemeData(),
        child: Material(child: child),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/custom/routes.dart';
import 'package:tendon_loader_lib/custom/custom_themes.dart';

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
    );
  }
}

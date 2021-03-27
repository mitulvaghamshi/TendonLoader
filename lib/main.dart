import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/app_routes.dart';
import 'package:tendon_loader/utils/app_themes.dart';

void main() => runApp(const TendonLoader());

class TendonLoader extends StatelessWidget {
  const TendonLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      title: 'Tendon Loader',
      themeMode: ThemeMode.system,
      initialRoute: Navigator.defaultRouteName,
    );
  }
}
// /\*(.|\n)*?\*/

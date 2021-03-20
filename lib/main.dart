import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/app_routes.dart';

void main() => runApp(TendonLoader()); // /\*(.|\n)*?\*/

class TendonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      title: 'Tendon Loader',
      initialRoute: Navigator.defaultRouteName,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        accentColor: Colors.white,
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      theme: ThemeData(
        accentColor: Colors.black,
        primaryColor: Colors.white,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

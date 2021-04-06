import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/utils/app_routes.dart';
import 'package:tendon_loader/utils/app_themes.dart';

Future<void> main() async {
  await Hive.initFlutter();
  runApp(const TendonLoader());
}

class TendonLoader extends StatelessWidget {
  const TendonLoader({Key/*?*/ key}) : super(key: key);

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
// dart --enable-experiment=non-nullable lib/main.dart
// dart migrate --skip-import-check

// It is an error to call [setState] unless [mounted] is true.
// if (!mounted) {
// return;
// }

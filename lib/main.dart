import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  await Hive.openBox<bool>(keyDarkModeBox);
  await Hive.openBox<Export>(keyExportBox);
  await Hive.openBox<UserState>(keyUserStateBox);
  await Hive.openBox<SettingsState>(keySettingsStateBox);
  runApp(const AppStateWidget(child: TendonLoader()));
}

class TendonLoader extends StatelessWidget {
  const TendonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _isDark = boxDarkMode.get(
      keyDarkModeBox,
      defaultValue: false,
    )!;
    return MaterialApp(
      routes: routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      title: 'Tendon Loader',
      initialRoute: Navigator.defaultRouteName,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      builder: (_, Widget? child) => CupertinoTheme(
        data: const CupertinoThemeData(),
        child: Material(child: child),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/emulator.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/timestamp.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/screens/app_settings.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/screens/homescreen.dart';
import 'package:tendon_loader/screens/livedata/live_data.dart';
import 'package:tendon_loader/screens/login.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/screens/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/webportal/homepage.dart';

late final Box<Export> boxExport; // app only
late final Box<UserState> boxUserState; // web and app
late final Box<SettingsState> boxSettingsState; // app only

final Map<String, WidgetBuilder> _routes = <String, WidgetBuilder>{
  Login.route: (_) => const Login(),
  LiveData.route: (_) => const LiveData(),
  HomePage.route: (_) => const HomePage(),
  HomeScreen.route: (_) => const HomeScreen(),
  NewMVCTest.route: (_) => const NewMVCTest(),
  MVCTesting.route: (_) => const MVCTesting(),
  AppSettings.route: (_) => const AppSettings(),
  NewExercise.route: (_) => const NewExercise(),
  ExerciseMode.route: (_) => const ExerciseMode(),
};

Future<void> _initializeApp() async {
  await Firebase.initializeApp();
  await useEmulator();
  await Hive.initFlutter();
  Hive.registerAdapter(UserStateAdapter());
  if (!kIsWeb) {
    Hive.registerAdapter(ExportAdapter());
    Hive.registerAdapter(ChartDataAdapter());
    Hive.registerAdapter(TimestampAdapter());
    Hive.registerAdapter(PrescriptionAdapter());
    Hive.registerAdapter(SettingsStateAdapter());
    boxExport = await Hive.openBox<Export>(keyExportBox);
    boxSettingsState = await Hive.openBox<SettingsState>(keySettingsStateBox);
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  }
  boxUserState = await Hive.openBox<UserState>(keyUserStateBox);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();
  runApp(const AppStateWidget(child: TendonLoader()));
}

class TendonLoader extends StatelessWidget {
  const TendonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: _routes,
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

import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_tile.dart';
import 'package:tendon_loader/exercise/exercise_mode.dart';
import 'package:tendon_loader/handler/dialog_handler.dart';
import 'package:tendon_loader/livedata/live_data.dart';
import 'package:tendon_loader/mvctest/mvc_testing.dart';
import 'package:tendon_loader/settings/user_settings.dart';
import 'package:tendon_loader/utils/helper.dart';
import 'package:tendon_loader/utils/route_type.dart';
import 'package:wakelock/wakelock.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String route = '/homeScreen';
  static const String name = 'Tendon Loader';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    if (localDataCount > 0) {
      Future<void>.delayed(const Duration(seconds: 2), () => tryUpload(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text(HomeScreen.name), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.settings_rounded),
          onPressed: () async => Navigator.pushNamed(context, UserSettings.route),
        ),
      ]),
      body: SingleChildScrollView(
        child: AppFrame(
          onExit: onAppClose,
          child: Column(children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: AppLogo()),
            CustomTile(
              name: LiveData.name,
              icon: Icons.show_chart_rounded,
              onTap: () => navigateTo(context, RouteType.liveData),
            ),
            CustomTile(
              name: MVCTesting.name,
              icon: Icons.airline_seat_legroom_extra,
              onTap: () => navigateTo(context, RouteType.mvcTest),
            ),
            CustomTile(
              name: ExerciseMode.name,
              icon: Icons.directions_run_rounded,
              onTap: () => navigateTo(context, RouteType.exerciseMode),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => connectProgressor(context),
        icon: const Icon(Icons.bluetooth_rounded),
        label: const Text('Connect Device'),
      ),
    );
  }
}

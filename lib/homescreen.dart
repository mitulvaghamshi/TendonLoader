import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/exercise/auto_exercise.dart';
import 'package:tendon_loader/exercise/exercise_mode.dart';
import 'package:tendon_loader/exercise/new_exercise.dart';
import 'package:tendon_loader/handler/dialog_handler.dart';
import 'package:tendon_loader/handler/location_handler.dart';
import 'package:tendon_loader/livedata/live_data.dart';
import 'package:tendon_loader/mvctest/mvc_testing.dart';
import 'package:tendon_loader/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/settings/app_settings.dart';
import 'package:wakelock/wakelock.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String route = '/home';
  static const String name = 'Tendon Loader';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    Wakelock.enable();
    tryAutoUpload(context);
    checkLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) checkLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text(HomeScreen.name), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.settings_rounded),
          onPressed: () async => Navigator.pushNamed(context, AppSettings.route),
        ),
      ]),
      body: SingleChildScrollView(
        child: AppFrame(
          onExit: onAppClose,
          child: Column(children: <Widget>[
            const SizedBox(height: 20),
            const AppLogo(),
            const SizedBox(height: 20),
            _CustomTile(
              name: LiveData.name,
              icon: Icons.show_chart_rounded,
              onTap: () => navigateTo(context, LiveData.route),
            ),
            _CustomTile(
              name: MVCTesting.name,
              icon: Icons.airline_seat_legroom_extra,
              onTap: () {
                if (AppStateScope.of(context).settingsState!.customPrescriptions!) {
                  navigateTo(context, NewMVCTest.route);
                } else {
                  if (AppStateScope.of(context).mvcDuration != null) {
                    navigateTo(context, MVCTesting.route);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'No MVC test available, '
                          'please contact your clinician or '
                          'turn on editable exercise in settings.',
                        ),
                      ),
                    );
                  }
                }
              },
            ),
            _CustomTile(
              name: ExerciseMode.name,
              icon: Icons.directions_run_rounded,
              onTap: () {
                if (AppStateScope.of(context).settingsState!.customPrescriptions!) {
                  navigateTo(context, NewExercise.route);
                } else {
                  if (AppStateScope.of(context).prescription != null) {
                    AutoExercise.show(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'No exercise prescription available, '
                          'please contact your clinician or '
                          'turn on editable exercise in settings.',
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => selectDevice(context),
        label: const Text('Connect Device'),
        icon: const Icon(Icons.bluetooth_rounded),
      ),
    );
  }
}

class _CustomTile extends StatelessWidget {
  const _CustomTile({
    Key? key,
    required this.name,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.all(16),
      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      leading: CustomButton(icon: Icon(icon, size: 30), onPressed: () {}),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}

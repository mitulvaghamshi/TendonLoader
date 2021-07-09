import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/descriptions.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/confirm_dialod.dart';
import 'package:tendon_loader/custom/countdown.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/device/device_tile.dart';
import 'package:tendon_loader/device/handler/device_handler.dart';
import 'package:tendon_loader/device/tiles/bluetooth_tile.dart';
import 'package:tendon_loader/exercise/auto_exercise.dart';
import 'package:tendon_loader/exercise/exercise_mode.dart';
import 'package:tendon_loader/exercise/new_exercise.dart';
import 'package:tendon_loader/homescreen.dart';
import 'package:tendon_loader/livedata/live_data.dart';
import 'package:tendon_loader/login/app_auth.dart';
import 'package:tendon_loader/login/initializer.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/user.dart';
import 'package:tendon_loader/mvctest/mvc_testing.dart';
import 'package:tendon_loader/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/route_type.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:wakelock/wakelock.dart';

Future<bool> get isConnected async => (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

int get localDataCount => boxExport.length;

Future<bool> onAppClose() async {
  await Wakelock.disable();
  await disconnectDevice();
  await signOut();
  disposeGraphData();
  return true;
}

Future<bool> submitData(BuildContext context, Export export, bool isLocal) async {
  return Future<bool>.microtask(() async {
    late bool result;
    if (!isLocal && await isConnected) {
      result = await export.upload(context);
    } else {
      await boxExport.add(export);
      result = true;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result ? 'Data stored successfully...' : 'Something wants wrong...'),
    ));
    return Future<bool>.value(result);
  });
}

Future<bool> _reSubmitData(BuildContext context) async {
  bool result = false;
  for (final Export export in boxExport.values) {
    result = await export.upload(context);
    if (result) await export.delete();
  }
  return Future<bool>.value(result);
}

Future<void> tryUpload(BuildContext context) async {
  final int _count = localDataCount;
  if (await isConnected && await _reSubmitData(context)) {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              const Text('Data Submitted', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
              CustomButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.check_rounded),
                child: const Text('Ok', style: TextStyle(color: colorGoogleGreen)),
              ),
            ]),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: ListTile(
            title: Text('$_count file${_count == 1 ? '' : 's'} uploaded', style: const TextStyle(fontSize: 20)),
            leading: CustomButton(
              onPressed: () {},
              color: colorGoogleGreen,
              icon: const Icon(Icons.check_rounded, size: 30),
            ),
          ),
        );
      },
    );
  }
}

void navigateTo(BuildContext context, RouteType route) {
  if (connectedDevice != null || simulateBT) {
    if (route == RouteType.liveData) {
      Navigator.pushNamed(context, LiveData.route);
    } else if (route == RouteType.mvcTest) {
      if (context.model.settingsState!.customPrescriptions!) {
        Navigator.pushNamed(context, NewMVCTest.route);
      } else {
        if (context.model.mvcDuration != null) {
          Navigator.pushNamed(context, MVCTesting.route);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(descNoMvcAvailable)));
        }
      }
    } else if (route == RouteType.exerciseMode) {
      if (context.model.settingsState!.customPrescriptions!) {
        Navigator.pushNamed(context, NewExercise.route);
      } else {
        if (context.model.prescription != null) {
          _startAutoExercise(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(descNoExerciseAvailable)));
        }
      }
    }
  } else {
    connectProgressor(context);
  }
}

Future<void> _startAutoExercise(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      scrollable: true,
      content: const AutoExercise(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text('Start Exercise', textAlign: TextAlign.center),
          CustomButton(
            reverce: true,
            icon: const Icon(Icons.arrow_forward_rounded, color: colorGoogleGreen),
            onPressed: () async => Navigator.pushReplacementNamed(context, ExerciseMode.route),
            child: const Text('Go', style: TextStyle(color: colorGoogleGreen)),
          ),
        ],
      ),
    ),
  );
}

Future<bool?> startCountdown(
  BuildContext context, {
  String title = 'Session start in...',
  Duration duration = const Duration(seconds: 5),
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CountDown(title: title, duration: duration),
  );
}

Future<bool?> confirmSubmit(BuildContext context, Export export) async {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      content: ConfirmDialog(export: export),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Submit data to Clinician?', textAlign: TextAlign.center),
    ),
  );
}

Future<void> connectProgressor(BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: connectedDevice != null ? DeviceTile(device: connectedDevice!) : const BluetoothTile(),
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        const Text('Connect Progressor', textAlign: TextAlign.center),
        CustomButton(
          radius: 20,
          icon: const Icon(Icons.clear, color: colorRed400),
          onPressed: () async => stopWeightMeas().then((_) => Navigator.pop(context)),
        ),
      ]),
    ),
  );
}

Future<void> congratulate(BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
            const Text('Congratulations!!!', textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
            CustomButton(
              reverce: true,
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.arrow_forward, color: colorGoogleGreen),
              child: const Text('Next', style: TextStyle(color: colorGoogleGreen)),
            ),
          ]),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text(
          'Exercise session completed!\nGreat work!',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      );
    },
  );
}

Future<void> setPrescriptions(BuildContext context, User _user) async {
  await showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      scrollable: true,
      content: NewExercise(user: _user),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

Future<void> confirmDelete(BuildContext context, VoidCallback action) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: const <Widget>[
          Icon(Icons.warning_rounded, size: 50),
          Text('Delete export(s)?', style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
        actions: <Widget>[
          CustomButton(
            elevation: 0,
            color: Colors.transparent,
            icon: const Icon(Icons.cancel),
            onPressed: Navigator.of(context).pop,
            child: const Text('Cencel'),
          ),
          CustomButton(
            radius: 16,
            onPressed: action,
            color: colorRed900,
            icon: const Icon(Icons.delete_rounded),
            child: const Text('Permanently delete'),
          ),
        ],
      );
    },
  );
}

void aboutDialog(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationVersion: 'v1.0',
    applicationName: HomeScreen.name,
    applicationIcon: const AppLogo(radius: 30),
    // applicationLegalese: 'Add Application Legalese',
    children: <Widget>[
      const Text(
        'Tendon Loader :Preview',
        textAlign: TextAlign.center,
        style: TextStyle(color: colorGoogleGreen, fontSize: 18, fontFamily: 'Georgia'),
      ),
      // const SizedBox(height: 20),
      // const Text(
      //   'Mitul Vaghamshi',
      //   textAlign: TextAlign.center,
      //   style: TextStyle(color: Colors.blue, fontSize: 20, fontFamily: 'Georgia', letterSpacing: 1.5),
      // ),
      // const SizedBox(height: 20),
      // const Text('mitulvaghmashi@gmail.com', textAlign: TextAlign.center),
    ],
  );
}

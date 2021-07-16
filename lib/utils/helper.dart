import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/descriptions.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/countdown.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/custom/custom_tile.dart';
import 'package:tendon_loader/device/connected_list.dart';
import 'package:tendon_loader/exercise/auto_exercise.dart';
import 'package:tendon_loader/exercise/exercise_mode.dart';
import 'package:tendon_loader/exercise/new_exercise.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/homescreen.dart';
import 'package:tendon_loader/livedata/live_data.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/user.dart';
import 'package:tendon_loader/mvctest/mvc_testing.dart';
import 'package:tendon_loader/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/utils/app_auth.dart';
import 'package:tendon_loader/utils/clip_player.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/initializer.dart';
import 'package:tendon_loader/utils/route_type.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:wakelock/wakelock.dart';

Future<bool> get _isNetworkOn async => (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

Future<void> _cleanup() async {
  await Wakelock.disable();
  await disconnectDevice();
  await firebaseLogout();
  disposeGraphData();
  releasePlayer();
  return Future<void>.delayed(const Duration(microseconds: 500));
}

Future<bool?> onAppClose(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (_) => CustomDialog(
      content: FutureBuilder<void>(
        future: _cleanup(),
        builder: (_, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) context.pop(true);
          return const CustomProgress();
        },
      ),
    ),
  );
}

void navigateTo(BuildContext context, [RouteType? type]) {
  if (type == null || progressor == null && !isSumulation) {
    _connectProgressor(context);
  } else {
    final bool isCustom = context.model.settingsState!.customPrescriptions!;
    if (type == RouteType.liveData) {
      context.push(LiveData.route);
    } else if (type == RouteType.mvcTest) {
      if (isCustom) {
        context.push(NewMVCTest.route);
      } else if (context.model.mvcDuration != null) {
        context.push(MVCTesting.route);
      } else {
        context.showSnackBar(const Text(descNoMvcAvailable));
      }
    } else if (type == RouteType.exerciseMode) {
      if (isCustom) {
        context.push(NewExercise.route);
      } else if (context.model.prescription != null) {
        _startAutoExercise(context);
      } else {
        context.showSnackBar(const Text(descNoExerciseAvailable));
      }
    }
  }
}

Future<bool?> submitData(BuildContext context, Export export) async {
  return context.model.settingsState!.autoUpload!
      ? await _isNetworkOn
          ? export.upload(context)
          : Future<bool>.value(true)
      : _confirmSubmit(context, export);
}

Future<int> _reSubmitData(BuildContext context) async {
  int count = 0;
  for (final Export export in boxExport.values) {
    if (await export.upload(context)) count++;
  }
  return count;
}

Future<void> tryUpload(BuildContext context) async {
  if (await _isNetworkOn) {
    await _reSubmitData(context).then((int count) async {
      return showDialog<void>(
        context: context,
        builder: (_) => FittedBox(
          child: CustomDialog(
            title: 'Data upload complate',
            content: CustomTile(name: '$count file(s) uploaded', icon: Icons.check_rounded, onTap: context.pop),
          ),
        ),
      );
    });
  }
}

Future<bool?> _confirmSubmit(BuildContext context, Export export) async {
  return showDialog<bool?>(
    context: context,
    barrierDismissible: false,
    builder: (_) => FittedBox(
      child: CustomDialog(
        title: 'Submit data?',
        content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          CustomTile(
            name: 'Submit Now',
            color: colorGoogleGreen,
            icon: Icons.cloud_upload_rounded,
            onTap: () => export.upload(context).then(context.pop),
          ),
          CustomTile(
            name: 'Do it later',
            color: colorYellow400,
            icon: Icons.save_rounded,
            onTap: () => context.pop(true),
          ),
          CustomTile(
            name: 'Discard!',
            color: colorRed400,
            icon: Icons.clear_rounded,
            onTap: () => export.delete().then((_) => context.pop(true)),
          ),
        ]),
      ),
    ),
  );
}

Future<bool?> startCountdown(BuildContext context, {String? title, Duration? duration}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomDialog(
      title: title ?? 'Session start in...',
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: CountDown(duration: duration ?? const Duration(seconds: 5)),
      ),
    ),
  );
}

Future<void> _connectProgressor(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const CustomDialog(title: 'Connect Progressor', content: ConnectedList()),
  ).then((_) async {
    if (isBusy || isWorking) await stopWeightMeas();
  });
}

Future<void> congratulate(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (_) => const CustomDialog(
      title: 'Congratulation!',
      content: Text(
        'Exercise session completed.\nGreat work!!!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: colorGoogleGreen),
      ),
    ),
  );
}

Future<void> setPrescription(BuildContext context, User _user) async {
  return showDialog<void>(
    context: context,
    builder: (_) => CustomDialog(title: _user.id, content: NewExercise(user: _user)),
  );
}

Future<void> confirmDelete(BuildContext context, VoidCallback action) async {
  return showDialog<void>(
    context: context,
    builder: (_) => CustomDialog(
      title: 'Delete export(s)?',
      content: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        CustomButton(
          elevation: 0,
          onPressed: context.pop,
          color: Colors.transparent,
          icon: const Icon(Icons.cancel),
          child: const Text('Cencel'),
        ),
        CustomButton(
          radius: 8,
          onPressed: action,
          color: colorRed900,
          icon: const Icon(Icons.delete_rounded, color: colorWhite),
          child: const Text('Permanently delete', style: TextStyle(color: colorWhite)),
        ),
      ]),
    ),
  );
}

Future<void> _startAutoExercise(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (_) => CustomDialog(
      title: 'Start Exercise',
      content: const FittedBox(child: AutoExercise()),
      trieling: CustomButton(
        reverce: true,
        onPressed: () async {
          context.model.settingsState!.lastPrescriptions = context.model.prescription;
          await context.model.settingsState!.save();
          await context.push(ExerciseMode.route, replace: true);
        },
        icon: const Icon(Icons.arrow_forward_rounded, color: colorGoogleGreen),
        child: const Text('Go', style: TextStyle(color: colorGoogleGreen)),
      ),
    ),
  );
}

void about(BuildContext context) {
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

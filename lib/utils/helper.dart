import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/countdown.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/custom_picker.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/custom/custom_slider.dart';
import 'package:tendon_loader/custom/custom_tile.dart';
import 'package:tendon_loader/handlers/audio_handler.dart';
import 'package:tendon_loader/handlers/auth_handler.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/handlers/splash_handler.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/screens/device/connected_list.dart';
import 'package:tendon_loader/screens/exercise/auto_exercise.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/screens/homescreen.dart';
import 'package:tendon_loader/screens/livedata/live_data.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/screens/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/utils/constant/descriptions.dart';
import 'package:tendon_loader/utils/enums.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/textstyles.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:wakelock/wakelock.dart';

Future<bool> get _isNetworkOn async => (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

Future<void> _cleanup() async {
  await Wakelock.disable();
  await disconnectDevice();
  await firebaseLogout();
  await disposePlayer();
  disposeSelectedItem();
  return Future<void>.delayed(const Duration(microseconds: 800));
}

Future<bool?> onExit(BuildContext context) async {
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
            content: CustomTile(name: '$count file(s) submitted', icon: Icons.check),
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
        padding: const EdgeInsets.all(5),
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
  ).then((_) async => stopWeightMeas());
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

Future<void> confirmDelete(BuildContext context, VoidCallback onDelete) async {
  return showDialog<void>(
    context: context,
    builder: (_) => CustomDialog(
      title: 'Delete export(s)?',
      content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        TextButton(onPressed: context.pop, child: const Text('Cencel')),
        CustomButton(
          radius: 8,
          color: colorRed900,
          onPressed: () async {
            onDelete();
            context.view.refresh;
            context.pop();
          },
          icon: const Icon(Icons.delete, color: colorWhite),
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

Future<Duration?> selectTime(BuildContext context) {
  int _min = 0;
  int _sec = 0;
  return showDialog<Duration?>(
    context: context,
    builder: (_) => CustomDialog(
      title: 'Select Time (m:s)',
      trieling: CustomButton(
        radius: 25,
        icon: const Icon(Icons.done_rounded, color: colorGoogleGreen),
        onPressed: () => context.pop<Duration>(Duration(minutes: _min, seconds: _sec)),
      ),
      content: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        CustomPicker(onChanged: (int val) => _min = val),
        CustomPicker(onChanged: (int val) => _sec = val),
      ]),
    ),
  );
}

Future<double?> selectPain(BuildContext context) {
  double _value = 0;
  return showDialog<double>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomDialog(
      title: 'Pain score(0~10)',
      trieling: CustomButton(
        radius: 20,
        onPressed: () => context.pop<double>(_value),
        icon: const Icon(Icons.done_rounded, color: colorGoogleGreen),
      ),
      content: Column(children: <Widget>[
        const Text('Please describe your pain during that session', style: ts18BFF, textAlign: TextAlign.center),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: CustomSlider(onChanged: (double val) => _value = val),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          _buildPainText('0\n\nNo\npain', colorAGreen400),
          _buildPainText('5\n\nModerate\npain', colorModerate),
          _buildPainText('10\n\nWorst\npain', colorRed400),
        ]),
      ]),
    ),
  );
}

Text _buildPainText(String text, Color color) => Text(text,
    textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.w900, letterSpacing: 1.5));

Future<String?> selectTolerance(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomDialog(
      title: 'One more thing...',
      content: Column(
        children: <Widget>[
          const Text('Was the pain during that\ntolerable for you?', style: ts18BFF, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            CustomButton(
              onPressed: () => context.pop('Yes'),
              icon: const Icon(Icons.check, color: colorGoogleGreen),
              child: const Text('Yes', style: TextStyle(color: colorGoogleGreen)),
            ),
            const SizedBox(width: 5),
            CustomButton(
              onPressed: () => context.pop('No pain'),
              icon: const Icon(Icons.remove, color: colorModerate),
              child: const Text('No pain', style: TextStyle(color: colorModerate)),
            ),
            const SizedBox(width: 5),
            CustomButton(
              onPressed: () => context.pop('No'),
              icon: const Icon(Icons.clear, color: colorRed400),
              child: const Text('No', style: TextStyle(color: colorRed400)),
            ),
          ]),
        ],
      ),
    ),
  );
}

void about(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationVersion: 'v0.0.9',
    applicationName: HomeScreen.name,
    applicationIcon: const AppLogo(radius: 30),
    // applicationLegalese: 'Add Application Legalese',
    children: <Widget>[
      const Text(
        'Tendon Loader :Preview-v0.0.9',
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

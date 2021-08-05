import 'dart:async';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/countdown.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/custom_slider.dart';
import 'package:tendon_loader/custom/custom_tile.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

Future<bool?> startCountdown(BuildContext context, {String? title, Duration? duration}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomDialog(
      title: title ?? 'Session start in...',
      action: CustomButton(onPressed: context.pop, left: const Text('Stop'), right: const Icon(Icons.clear)),
      content: Padding(
        padding: const EdgeInsets.all(5),
        child: CountDown(duration: duration ?? const Duration(seconds: 5)),
      ),
    ),
  );
}

Future<void> congratulate(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomDialog(
      title: 'Congratulations!',
      action: CustomButton(
        onPressed: context.pop,
        left: const Text('Next'),
        right: const Icon(Icons.arrow_forward),
      ),
      content: const Text(
        'Exercise session completed.\nGreat work!!!',
        textAlign: TextAlign.center,
        style: tsG24B,
      ),
    ),
  );
}

Future<double?> selectPain(BuildContext context) {
  double _value = 0;
  return showDialog<double>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomDialog(
      title: 'Pain score (0 - 10)',
      action: CustomButton(
        left: const Text('Next'),
        right: const Icon(Icons.arrow_forward),
        onPressed: () => context.pop<double>(_value),
      ),
      content: Column(children: <Widget>[
        const Text('Please describe your pain during that session', style: ts18B, textAlign: TextAlign.center),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: StatefulBuilder(
            builder: (_, void Function(void Function()) setState) => CustomSlider(
              value: _value,
              onChanged: (double value) => setState(() => _value = value),
            ),
          ),
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
    textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.w500, letterSpacing: 1));

Future<String?> selectTolerance(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomDialog(
      title: 'Pain Tolerance',
      action: const SizedBox(width: 1, height: 1),
      content: Column(children: <Widget>[
        const Text('Was the pain during that session tolerable for you?', style: ts18B, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        FittedBox(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            CustomButton(
              onPressed: () => context.pop('Yes'),
              left: const Icon(Icons.check, color: colorGoogleGreen),
              right: const Text('Yes', style: TextStyle(color: colorGoogleGreen)),
            ),
            const SizedBox(width: 5),
            CustomButton(
              onPressed: () => context.pop('No'),
              left: const Icon(Icons.clear, color: colorRed400),
              right: const Text('No', style: TextStyle(color: colorRed400)),
            ),
            const SizedBox(width: 5),
            CustomButton(
              left: const Text('No pain'),
              right: const Icon(Icons.arrow_forward),
              onPressed: () => context.pop('No pain'),
            ),
          ]),
        ),
      ]),
    ),
  );
}

Future<bool?> submitData(BuildContext context, Export export) async {
  return context.model.settingsState!.autoUpload!
      ? await Connectivity().checkConnectivity() != ConnectivityResult.none
          ? export.upload(context)
          : Future<bool>.value(true)
      : confirmSubmit(context, export);
}

Future<bool?> confirmSubmit(BuildContext context, Export export) async {
  return showDialog<bool?>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomDialog(
      title: 'Submit data?',
      action: CustomButton(
        left: const Text('Discard'),
        right: const Icon(Icons.clear, color: colorRed400),
        onPressed: () => export.delete().then((_) => context.pop(true)),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        CustomTile(
          title: 'Submit Now',
          onTap: () => export.upload(context).then(context.pop),
          left: const Icon(Icons.cloud_upload, color: colorGoogleGreen),
        ),
        CustomTile(
          title: 'Do it later',
          onTap: () => context.pop(true),
          left: const Icon(Icons.save, color: colorYellow400),
        ),
      ]),
    ),
  );
}

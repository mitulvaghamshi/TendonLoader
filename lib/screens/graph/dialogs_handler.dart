/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

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
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/themes.dart';

Future<bool?> startCountdown(
  BuildContext context, {
  String? title,
  Duration? duration,
}) {
  return CustomDialog.show<bool>(
    context,
    title: title ?? 'Session start in...',
    action: CustomButton(
      onPressed: context.pop,
      left: const Text('Stop'),
      right: const Icon(Icons.clear),
    ),
    content: Padding(
      padding: const EdgeInsets.all(5),
      child: CountDown(duration: duration ?? const Duration(seconds: 5)),
    ),
  );
}

Future<void> congratulate(BuildContext context) async {
  return CustomDialog.show<void>(
    context,
    title: 'Congratulations!',
    action: CustomButton(
      onPressed: context.pop,
      left: const Text('Next'),
      right: const Icon(Icons.arrow_forward),
    ),
    content: const Text(
      'Exercise session completed.\nGreat work!!!',
      textAlign: TextAlign.center,
      style: tsG20B,
    ),
  );
}

Future<double?> selectPain(BuildContext context) {
  double _value = 0;
  return CustomDialog.show<double>(
    context,
    title: 'Pain score (0 - 10)',
    action: CustomButton(
      left: const Text('Next'),
      right: const Icon(Icons.arrow_forward),
      onPressed: () => context.pop<double>(_value),
    ),
    content: Column(children: <Widget>[
      const Text(
        'Please describe your pain during that session',
        textAlign: TextAlign.center,
        style: ts18w5,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: StatefulBuilder(
          builder: (_, void Function(void Function()) setState) {
            return CustomSlider(
              value: _value,
              onChanged: (double value) {
                setState(() => _value = value);
              },
            );
          },
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildPainText('0\n\nNo\npain', colorDarkGreen),
          _buildPainText('5\n\nModerate\npain', colorModerate),
          _buildPainText('10\n\nWorst\npain', colorErrorRed),
        ],
      ),
    ]),
  );
}

Text _buildPainText(String text, Color color) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: color,
      letterSpacing: 1,
      fontWeight: FontWeight.w500,
    ),
  );
}

Future<String?> selectTolerance(BuildContext context) {
  return CustomDialog.show<String>(
    context,
    title: 'Pain Tolerance',
    action: const SizedBox(width: 1, height: 1),
    content: Column(children: <Widget>[
      const Text(
        'Was the pain during that session tolerable for you?',
        textAlign: TextAlign.center,
        style: ts18w5,
      ),
      const SizedBox(height: 16),
      FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CustomButton(
              onPressed: () => context.pop('Yes'),
              left: const Icon(Icons.check, color: colorMidGreen),
              right: const Text(
                'Yes',
                style: TextStyle(color: colorMidGreen),
              ),
            ),
            const SizedBox(width: 5),
            CustomButton(
              onPressed: () => context.pop('No'),
              left: const Icon(Icons.clear, color: colorErrorRed),
              right: const Text('No', style: TextStyle(color: colorErrorRed)),
            ),
            const SizedBox(width: 5),
            CustomButton(
              left: const Text('No pain'),
              right: const Icon(Icons.arrow_forward),
              onPressed: () => context.pop('No pain'),
            ),
          ],
        ),
      ),
    ]),
  );
}

Future<bool?> submitData(BuildContext context, Export export) async {
  return settingsState.autoUpload!
      ? await Connectivity().checkConnectivity() != ConnectivityResult.none
          ? export.upload()
          : Future<bool>.value(true)
      : confirmSubmit(context, export);
}

Future<bool?> confirmSubmit(BuildContext context, Export export) async {
  return CustomDialog.show<bool>(
    context,
    title: 'Submit data?',
    action: CustomButton(
      left: const Text('Discard'),
      right: const Icon(Icons.clear, color: colorErrorRed),
      onPressed: () => export.delete().then((_) => context.pop(true)),
    ),
    content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      CustomTile(
        title: 'Submit Now',
        onTap: () => export.upload().then(context.pop),
        left: const Icon(Icons.cloud_upload, color: colorMidGreen),
      ),
      CustomTile(
        title: 'Do it later',
        onTap: () => context.pop(true),
        left: const Icon(Icons.save, color: colorMidOrange),
      ),
    ]),
  );
}

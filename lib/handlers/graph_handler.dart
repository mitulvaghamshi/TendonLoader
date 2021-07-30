import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/custom/countdown.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/custom_slider.dart';
import 'package:tendon_loader/custom/custom_tile.dart';
import 'package:tendon_loader/handlers/audio_handler.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/screens/login/splash.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/progressor.dart';
import 'package:tendon_loader/utils/themes.dart';

// Simuation block start
late Timer? _timer;
late bool isSumulation;

void _fakeStart() {
  double _fakeLoad = 0;
  _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    if (!isPause) {
      final ChartData element = ChartData(load: _fakeLoad, time: timer.tick.toDouble());
      GraphHandler.exportData.add(element);
      GraphHandler.sink.add(element);
      _fakeLoad = _fakeLoad > 15 ? 0 : _fakeLoad + .5;
    }
  });
}
// Simulation block end

bool isPause = false;

class GraphHandler {
  GraphHandler({required this.context, this.lineData}) : userId = context.model.currentUser!.id {
    isRunning = isComplete = hasData = false;
    stream.listen(update);
  }

  bool isHit = false;

  late bool hasData;
  final String userId;
  late bool isRunning;
  late bool isComplete;
  late Timestamp timestamp;

  final BuildContext context;

  List<ChartData>? lineData;
  ChartSeriesController? lineCtrl;
  ChartSeriesController? graphCtrl;
  final List<ChartData> graphData = <ChartData>[];

  @protected
  Export? export;
  @protected
  static final List<ChartData> exportData = <ChartData>[];

  static final BehaviorSubject<ChartData> _controller = BehaviorSubject<ChartData>.seeded(ChartData());
  static Stream<ChartData> get stream => _controller.stream;
  static Sink<ChartData> get sink => _controller.sink; // simulation

  Color get feedColor => isHit ? colorGoogleGreen : colorWhite;

  static void clear() {
    _lastMillis = 0;
    _controller.sink.add(ChartData());
  }

  static void disposeGraphData() {
    if (!_controller.isClosed) _controller.close();
  }

  static double _lastMillis = 0;
  static void onData(List<int> data) {
    if (!isPause && data.isNotEmpty && data[0] == resWeightMeasurement) {
      for (int x = 2; x < data.length; x += 8) {
        final double weight = data.getRange(x, x + 4).toList().toWeight;
        final double time = data.getRange(x + 4, x + 8).toList().toTime;
        if (time > _lastMillis) {
          _lastMillis = time;
          final ChartData element = ChartData(load: weight, time: time);
          exportData.add(element);
          _controller.sink.add(element);
        }
      }
    }
  }

  @mustCallSuper
  Future<void> start() async {
    if (await startCountdown(context) ?? false) {
      play(true);
      hasData = true;
      isRunning = true;
      isComplete = false;
      exportData.clear();
      timestamp = Timestamp.now();
      //
      if (isSumulation) {
        _fakeStart();
      } else {
        await startWeightMeas();
      }
      //
      await HapticFeedback.heavyImpact();
    }
  }

  void pause() {}

  void update(ChartData data) {}

  @mustCallSuper
  Future<void> stop() async {
    //
    if (isSumulation) {
      _timer?.cancel();
    } else {
      await stopWeightMeas();
    }
    //
    play(false);
  }

  @mustCallSuper
  Future<bool> exit() async {
    if (!hasData) return true;
    if (!export!.isInBox) {
      export!
        ..userId = userId
        ..timestamp = timestamp
        ..isComplate = isComplete
        ..progressorId = deviceName
        ..exportData = exportData;
      await boxExport.add(export!);
    }
    if (isRunning) await stop();

    export!.painScore ??= await _selectPain(context);
    export!.isTolerable ??= await _selectTolerance(context);
    await export!.save();

    if (export!.painScore == null || export!.isTolerable == null) return false;

    final bool? result = await _submitData(context, export!);
    if (result == null) {
      return false;
    } else if (result) {
      hasData = false;
      export = null;
    }
    return result;
  }
}

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
      content: const Text('Exercise session completed.\nGreat work!!!', textAlign: TextAlign.center, style: tsG24B),
    ),
  );
}

Future<double?> _selectPain(BuildContext context) {
  double _value = 0;
  return showDialog<double>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomDialog(
      title: 'Pain score (0 - 10)',
      action: CustomButton(
        onPressed: () => context.pop<double>(_value),
        left: const Text('Next'),
        right: const Icon(Icons.arrow_forward),
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
    textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.w900, letterSpacing: 1.5));

Future<String?> _selectTolerance(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomDialog(
      title: 'Was tolerable?',
      action: CustomButton(
        left: const Text('No pain'),
        right: const Icon(Icons.arrow_forward),
        onPressed: () => context.pop('No pain'),
      ),
      content: Column(children: <Widget>[
        const Text('Was the pain during that session tolerable for you?', style: ts18B, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
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
        ]),
      ]),
    ),
  );
}

Future<bool?> _submitData(BuildContext context, Export export) async {
  return context.model.settingsState!.autoUpload!
      ? await Connectivity().checkConnectivity() != ConnectivityResult.none
          ? export.upload(context)
          : Future<bool>.value(true)
      : _confirmSubmit(context, export);
}

Future<bool?> _confirmSubmit(BuildContext context, Export export) async {
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

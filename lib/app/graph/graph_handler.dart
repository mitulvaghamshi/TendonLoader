import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/app/bluetooth/bluetooth_handler.dart';
import 'package:tendon_loader/app/widgets/countdown_widget.dart';
import 'package:tendon_loader/app/widgets/custom_tile.dart';
import 'package:tendon_loader/app/widgets/slider_widget.dart';
import 'package:tendon_loader/shared/models/chartdata.dart';
import 'package:tendon_loader/shared/models/export.dart';
import 'package:tendon_loader/shared/utils/common.dart';
import 'package:tendon_loader/shared/utils/constants.dart';
import 'package:tendon_loader/shared/utils/extension.dart';
import 'package:tendon_loader/shared/widgets/alert_widget.dart';
import 'package:tendon_loader/shared/widgets/button_widget.dart';

extension on List<int> {
  ByteData get _bytes => Uint8List.fromList(this).buffer.asByteData();

  double get toTime => double.parse(
      (_bytes.getUint32(0, Endian.little) / 1000000.0).toStringAsFixed(1));

  double get toWeight => double.parse(
      (_bytes.getFloat32(0, Endian.little).abs()).toStringAsFixed(2));
}

bool isPause = false;

class GraphHandler {
  GraphHandler({required this.context, this.lineData}) : userId = patient.id {
    isRunning = isComplete = hasData = false;
    stream.listen(update);
    clear();
  }

  bool isHit = false;

  final BuildContext context;

  List<ChartData>? lineData;
  ChartSeriesController? lineCtrl;
  ChartSeriesController? graphCtrl;

  late bool hasData;
  late bool isRunning;
  late bool isComplete;
  final String userId;
  late Timestamp timestamp;
  final List<ChartData> graphData = <ChartData>[];

  @protected
  Export? export;

  @protected
  static final List<ChartData> exportData = <ChartData>[];

  static final BehaviorSubject<ChartData> _controller =
      BehaviorSubject<ChartData>.seeded(ChartData());

  static Stream<ChartData> get stream => _controller.stream;
  static Sink<ChartData> get sink => _controller.sink;

  static double _lastMillis = 0;

  Color get feedColor =>
      isHit ? const Color(0xff3ddc85) : const Color(0xffffffff);

  static void clear() {
    _lastMillis = 0;
    _controller.sink.add(ChartData());
  }

  static void disposeGraphData() {
    if (!_controller.isClosed) _controller.close();
  }

  static void onData(List<int> data) {
    if (!isPause && data.isNotEmpty && data[0] == resWeightMeasurement) {
      for (int x = 2; x < data.length; x += 8) {
        final double weight = data.getRange(x, x + 4).toList().toWeight;
        final double time = data.getRange(x + 4, x + 8).toList().toTime;
        if (time > _lastMillis) {
          _lastMillis = time;
          final ChartData element = ChartData(load: weight, time: time);
          exportData.add(element);
          sink.add(element);
        }
      }
    }
  }

  @mustCallSuper
  Future<void> start() async {
    if (await startCountdown() ?? false) {
      hasData = true;
      isRunning = true;
      isComplete = false;
      exportData.clear();
      exportData.add(ChartData());
      timestamp = Timestamp.now();
      await startWeightMeas();
    }
  }

  void pause() {}

  void update(ChartData data) {}

  @mustCallSuper
  Future<void> stop() async {
    await stopWeightMeas();
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

    export!.painScore ??= await _selectPain();
    export!.isTolerable ??= await _selectTolerance();
    await export!.save();

    if (export!.painScore == null || export!.isTolerable == null) {
      return false;
    }

    final bool? result = await _submitData();
    if (result == null) {
      return false;
    } else if (result) {
      hasData = false;
      export = null;
    }
    isPause = false;
    return result;
  }

  Future<bool?> startCountdown({String? title, Duration? duration}) {
    return AlertWidget.show<bool>(
      context,
      title: title ?? 'Session start in...',
      action: ButtonWidget(
        onPressed: context.pop,
        left: const Text('Stop'),
        right: const Icon(Icons.clear),
      ),
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: CountdownWidget(
          duration: duration ?? const Duration(seconds: 5),
        ),
      ),
    );
  }

  Future<void> congratulate() async {
    return AlertWidget.show<void>(
      context,
      title: 'Congratulations!',
      action: ButtonWidget(
        onPressed: context.pop,
        left: const Text('Next'),
        right: const Icon(Icons.arrow_forward),
      ),
      content: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Exercise session completed.\nGreat work!!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Color(0xff3ddc85),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<double?> _selectPain() {
    double _value = 0;
    return AlertWidget.show<double>(
      context,
      title: 'Pain score (0 - 10)',
      action: ButtonWidget(
        left: const Text('Next'),
        right: const Icon(Icons.arrow_forward),
        onPressed: () => context.pop<double>(_value),
      ),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: <Widget>[
          const Text(
            'Please describe your pain during that session',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: StatefulBuilder(
              builder: (_, void Function(void Function()) setState) {
                return SliderWidget(
                  value: _value,
                  onChanged: (double value) => setState(() => _value = value),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildPainText('0\n\nNo\npain', const Color(0xff00e676)),
              _buildPainText('5\n\nModerate\npain', const Color(0xff7f9c61)),
              _buildPainText('10\n\nWorst\npain', const Color(0xffff534d)),
            ],
          ),
        ]),
      ),
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

  Future<String?> _selectTolerance() {
    return AlertWidget.show<String>(
      context,
      title: 'Pain Tolerance',
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: <Widget>[
          const Text(
            'Was the pain during that session tolerable for you?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ButtonWidget(
                  onPressed: () => context.pop('Yes'),
                  left: const Icon(Icons.check, color: Color(0xff3ddc85)),
                  right: const Text(
                    'Yes',
                    style: TextStyle(color: Color(0xff3ddc85)),
                  ),
                ),
                const SizedBox(width: 5),
                ButtonWidget(
                  onPressed: () => context.pop('No'),
                  left: const Icon(Icons.clear, color: Color(0xffff534d)),
                  right: const Text('No',
                      style: TextStyle(color: Color(0xffff534d))),
                ),
                const SizedBox(width: 5),
                ButtonWidget(
                  left: const Text('No pain'),
                  right: const Icon(Icons.arrow_forward),
                  onPressed: () => context.pop('No pain'),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<bool?> _submitData() async {
    return settingsState.autoUpload!
        ? await Connectivity().checkConnectivity() != ConnectivityResult.none
            ? export!.upload()
            : Future<bool>.value(true)
        : _confirmSubmit();
  }

  Future<bool?> _confirmSubmit() async {
    return AlertWidget.show<bool>(
      context,
      title: 'Submit data?',
      action: ButtonWidget(
        left: const Text('Discard'),
        right: const Icon(Icons.clear, color: Color(0xffff534d)),
        onPressed: () => export!.delete().then((_) => context.pop(true)),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        CustomTile(
          title: 'Submit Now',
          onTap: () => export!.upload().then(context.pop),
          left: const Icon(Icons.cloud_upload, color: Color(0xff3ddc85)),
        ),
        CustomTile(
          title: 'Do it later',
          onTap: () => context.pop(true),
          left: const Icon(Icons.save, color: Color(0xffe18f3c)),
        ),
      ]),
    );
  }
}

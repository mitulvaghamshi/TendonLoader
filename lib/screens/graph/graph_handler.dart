/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/bluetooth/device_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/screens/graph/dialogs_handler.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/themes.dart';

extension on List<int> {
  ByteData get _bytes => Uint8List.fromList(this).buffer.asByteData();

  double get toTime => double.parse(
      (_bytes.getUint32(0, Endian.little) / 1000000.0).toStringAsFixed(1));

  double get toWeight => double.parse(
      (_bytes.getFloat32(0, Endian.little).abs()).toStringAsFixed(2));
}

final AudioPlayer _player = AudioPlayer(playerId: 'FeedbackClipPlayer');

final AudioCache _playerCache = AudioCache(
  respectSilence: true,
  prefix: audioRoot,
  fixedPlayer: _player,
)..loadAll(<String>[keyStartClip, keyStopClip]);

Future<void> disposePlayer() async => _player.dispose();

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

  static double _lastMillis = 0;

  Color get feedColor => isHit ? colorMidGreen : colorPrimaryWhite;

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
          _controller.sink.add(element);
        }
      }
    }
  }

  @mustCallSuper
  Future<void> start() async {
    if (await startCountdown(context) ?? false) {
      hasData = true;
      isRunning = true;
      isComplete = false;
      exportData.clear();
      exportData.add(ChartData());
      timestamp = Timestamp.now();
      await startWeightMeas();
      await _playerCache.play(keyStartClip);
    }
  }

  void pause() {}

  void update(ChartData data) {}

  @mustCallSuper
  Future<void> stop() async {
    await stopWeightMeas();
    await _playerCache.play(keyStopClip);
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

    export!.painScore ??= await selectPain(context);
    export!.isTolerable ??= await selectTolerance(context);
    await export!.save();

    if (export!.painScore == null || export!.isTolerable == null) {
      return false;
    }

    final bool? result = await submitData(context, export!);
    if (result == null) {
      return false;
    } else if (result) {
      hasData = false;
      export = null;
    }
    isPause = false;
    return result;
  }
}

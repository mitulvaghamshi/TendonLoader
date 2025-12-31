import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/handlers/bluetooth_handler.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/utils/constants.dart';

bool isPause = false;

abstract class GraphHandler {
  GraphHandler({this.lineData, required this.onCountdown}) {
    isRunning = isComplete = hasData = false;
    stream.listen(update);
    reset();
  }

  final Future<bool?> Function(String title, Duration duration) onCountdown;

  final List<ChartData>? lineData;

  ChartSeriesController<ChartData, int>? lineCtrl;
  ChartSeriesController<ChartData, int>? graphCtrl;

  bool isHit = false;

  late bool hasData;
  late bool isRunning;
  late bool isComplete;
  late DateTime datetime;

  final graphData = <ChartData>[];

  @protected
  Exercise? export;

  @protected
  static final exportData = <ChartData>[];

  static final _controller = BehaviorSubject.seeded(const ChartData());
  static Sink<ChartData> get sink => _controller.sink;
  static Stream<ChartData> get stream => _controller.stream;

  static double _lastMillis = 0;

  static void reset() {
    _lastMillis = 0;
    _controller.sink.add(const ChartData());
  }

  static void onData(List<int> list) {
    if (!isPause && list.isNotEmpty && list[0] == Responses.weightMeasurement) {
      for (var x = 2; x < list.length; x += 8) {
        final weight = list.getRange(x, x + 4).toList().toWeight;
        final time = list.getRange(x + 4, x + 8).toList().toTime;
        if (time > _lastMillis) {
          _lastMillis = time;
          final data = ChartData(load: weight, time: time);
          exportData.add(data);
          sink.add(data);
        }
      }
    }
  }

  @mustCallSuper
  Future<void> start() async {
    final result = await onCountdown(
      'Session starts in...',
      const Duration(seconds: 5),
    );
    if (result ?? false) {
      datetime = .now();
      hasData = true;
      isRunning = true;
      isComplete = false;
      exportData
        ..clear()
        ..add(const ChartData());
      await Progressor.instance.startProgresssor();
    }
  }

  void pause();

  void update(ChartData data);

  @mustCallSuper
  Future<void> stop() async => Progressor.instance.stopProgressor();

  @mustCallSuper
  Future<String> exit() async {
    if (!hasData) {
      return '';
    }
    if ( /* !export!.isInBox */ true) {
      export?.copyWith(
        userId: 0,
        datetime: datetime.toString(),
        completed: isComplete,
        progressorId: Progressor.instance.deviceName,
        data: exportData,
      );
      // await AppScope.of(context).addToBox(export!);
    }
    if (isRunning) {
      await stop();
    }

    const String key = /* export!.key */ 'key';

    export = null;
    hasData = false;
    isPause = false;

    return key;
  }

  @mustCallSuper
  void dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}

extension ExGraphHandler on GraphHandler {
  Color get feedColor => isHit ? const Color(0xff3ddc85) : Colors.transparent;
}

extension on List<int> {
  ByteData get _bytes => Uint8List.fromList(this).buffer.asByteData();

  double get toTime =>
      .parse((_bytes.getUint32(0, .little) / 1_000_000.0).toStringAsFixed(1));

  double get toWeight =>
      .parse(_bytes.getFloat32(0, .little).abs().toStringAsFixed(2));
}

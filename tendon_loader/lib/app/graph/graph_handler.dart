import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/subjects.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/app/bluetooth/models/bluetooth_handler.dart';
import 'package:tendon_loader/app/graph/countdown_widget.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/widgets/raw_button.dart';

bool isPause = false;

abstract class GraphHandler with Progressor {
  GraphHandler({this.lineData, required this.onCountdown}) {
    isRunning = isComplete = hasData = false;
    stream.listen(update);
    clear();
  }

  final Future<bool?> Function(String title, Duration duration) onCountdown;

  final List<ChartData>? lineData;

  ChartSeriesController? lineCtrl;
  ChartSeriesController? graphCtrl;

  bool isHit = false;
  late bool hasData;
  late bool isRunning;
  late bool isComplete;
  late DateTime datetime;
  final List<ChartData> graphData = <ChartData>[];

  @protected
  Exercise? export;

  @protected
  static final List<ChartData> exportData = <ChartData>[];

  static final BehaviorSubject<ChartData> _controller =
      BehaviorSubject<ChartData>.seeded(const ChartData());

  static Stream<ChartData> get stream => GraphHandler._controller.stream;
  static Sink<ChartData> get sink => GraphHandler._controller.sink;

  static double _lastMillis = 0;

  static void clear() {
    _lastMillis = 0;
    _controller.sink.add(const ChartData());
  }

  static void disposeGraphData() {
    if (!_controller.isClosed) _controller.close();
  }

  static void onData(List<int> data) {
    if (!isPause && data.isNotEmpty && data[0] == Responses.weightMeasurement) {
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
    final bool? result = await onCountdown(
      'Session Start in...',
      const Duration(seconds: 5),
    );
    if (result ?? false) {
      datetime = DateTime.now();
      hasData = true;
      isRunning = true;
      isComplete = false;
      exportData
        ..clear()
        ..add(const ChartData());
      await startProgresssor();
    }
  }

  void pause();

  void update(ChartData data);

  @mustCallSuper
  Future<void> stop() async => stopProgressor();

  @mustCallSuper
  Future<String> exit() async {
    if (!hasData) return '';
    if (/* !export!.isInBox */ true) {
      export?.copyWith(
        userId: 0,
        datetime: datetime.toString(),
        completed: isComplete,
        progressorId: progressorName,
        data: exportData,
      );
      // await AppScope.of(context).addToBox(export!);
    }
    if (isRunning) await stop();
    const String key = /* export!.key */ 'key';

    export = null;
    hasData = false;
    isPause = false;

    return key;
  }
}

extension ExGraphHandler on GraphHandler {
  Color get feedColor =>
      isHit ? const Color(0xff3ddc85) : const Color(0xffffffff);
}

extension on List<int> {
  ByteData get _bytes => Uint8List.fromList(this).buffer.asByteData();

  double get toTime => double.parse(
      (_bytes.getUint32(0, Endian.little) / 1000000.0).toStringAsFixed(1));

  double get toWeight => double.parse(
      _bytes.getFloat32(0, Endian.little).abs().toStringAsFixed(2));
}

Future<bool?> startCountdown({
  required BuildContext context,
  required String title,
  required Duration duration,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(title, style: Styles.numPickerText),
          ),
          CountdownWidget(duration: duration),
          RawButton.tile(
            leading: const Text('Cancel'),
            onTap: context.pop,
            child: const Icon(Icons.clear, color: Color(0xffff534d)),
          ),
        ],
      ),
    ),
  );
}

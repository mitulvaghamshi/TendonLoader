import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/models/chartdata.dart';

final class LiveDataHandler extends GraphHandler {
  LiveDataHandler({required super.onCountdown});

  double _time = 0;

  @override
  Future<void> start() async {
    if (!isRunning) await super.start();
  }

  @override
  Future<void> stop() async {
    if (isRunning) {
      isRunning = hasData = false;
      await super.stop();
      _time = 0;
      GraphHandler.clear();
    }
  }

  @override
  void update(ChartData data) {
    if (isRunning) _time = data.time;
  }

  @override
  Future<String> exit() async {
    await stop();
    return super.exit();
  }

  @override
  void pause() {}
}

extension ExLiveDataHandler on LiveDataHandler {
  String get timeElapsed {
    final int seconds = _time ~/ 60;
    final String millis = (_time % 60).toStringAsFixed(0).padLeft(2, '0');
    return '🕒 $seconds:$millis Sec';
  }
}

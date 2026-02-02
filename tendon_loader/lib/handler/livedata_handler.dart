import 'package:api_server/api_server.dart';
import 'package:tendon_loader/handler/graph_handler.dart';

class LiveDataHandler extends GraphHandler {
  LiveDataHandler({required super.onCountdown});

  double _time = 0;

  @override
  Future<void> start() async {
    if (!isSessionRunning) {
      await super.start();
    }
  }

  @override
  Future<void> stop() async {
    if (isSessionRunning) {
      isSessionRunning = hasData = false;
      await super.stop();
      _time = 0;
      GraphHandler.reset();
    }
  }

  @override
  void update(ChartData data) {
    if (isSessionRunning) {
      _time = data.time;
    }
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
    final seconds = _time ~/ 60;
    final millis = (_time % 60).toStringAsFixed(0).padLeft(2, '0');
    return '🕒 $seconds:$millis Sec';
  }
}

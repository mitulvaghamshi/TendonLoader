import 'dart:async';

class Location {
  static final StreamController<bool> _controller = StreamController<bool>.broadcast();

  static Stream<bool> get stream => _controller.stream;

  static StreamSink<bool> get sink => _controller.sink;

  static void dispose() {
    if (!_controller.isClosed) _controller.close();
  }
}

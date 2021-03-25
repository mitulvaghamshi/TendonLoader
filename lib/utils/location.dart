import 'dart:async';

import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

extension Locator on Location {
  static final BehaviorSubject<bool> _controller = BehaviorSubject<bool>.seeded(false);

  static Stream<bool> get stream => _controller.stream;

  static StreamSink<bool> get sink => _controller.sink;

  static void dispose() {
    if (!_controller.isClosed) _controller.close();
  }
}

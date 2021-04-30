import 'dart:async';

import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

mixin Locator {
  static final BehaviorSubject<bool> _controller = BehaviorSubject<bool>.seeded(false);

  static Stream<bool> get stream => _controller.stream;

  static StreamSink<bool> get sink => _controller.sink;

  static Future<void> init() async => sink.add(await Location.instance.serviceEnabled());

  static Future<void> requestService() async => sink.add(await Location.instance.requestService());

  static void dispose() {
    if (!_controller.isClosed) _controller.close();
  }
}

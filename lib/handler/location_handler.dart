import 'dart:async' show Future, Stream;

import 'package:app_settings/app_settings.dart';
import 'package:location/location.dart' show Location;
import 'package:rxdart/rxdart.dart' show BehaviorSubject;

mixin Locator {
  static final BehaviorSubject<bool> _controller = BehaviorSubject<bool>.seeded(false);

  static Stream<bool> get stream => _controller.stream;

  static Future<void> enable() async => AppSettings.openLocationSettings();

  static Future<void> check() async => _controller.sink.add(await Location.instance.serviceEnabled());

  static void dispose() {
    if (!_controller.isClosed) _controller.close();
  }
}

import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

mixin Locator {
  static final BehaviorSubject<bool> _controller = BehaviorSubject<bool>.seeded(false);

  static Stream<bool> get stream => _controller.stream;

  static Future<void> check() async => _controller.sink.add(await Location.instance.serviceEnabled());

  static Future<void> enable() async => AppSettings.openLocationSettings();

  static void dispose() {
    if (!_controller.isClosed) _controller.close();
  }
}

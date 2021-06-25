import 'dart:async' show Future, Stream;

import 'package:app_settings/app_settings.dart';
import 'package:location/location.dart' show Location;
import 'package:rxdart/rxdart.dart' show BehaviorSubject;

final BehaviorSubject<bool> _controller = BehaviorSubject<bool>.seeded(false);

Stream<bool> get locationStream => _controller.stream;

Future<void> enableLocation() async => AppSettings.openLocationSettings();

Future<void> checkLocation() async {
  if (!_controller.isClosed) {
    _controller.sink.add(await Location.instance.serviceEnabled());
  }
}

void disposeLocationHandler() {
  if (!_controller.isClosed) _controller.close();
}

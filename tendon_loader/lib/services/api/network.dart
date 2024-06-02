import 'dart:async' show StreamSubscription;

import 'package:connectivity_plus/connectivity_plus.dart';

final class Network {
  factory Network() => _instance ??= Network._();

  Network._() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((value) => _result = value.first);
  }

  static Network? _instance;
  static StreamSubscription? _subscription;

  ConnectivityResult _result = ConnectivityResult.none;

  static bool get isConnected => _instance?._result != ConnectivityResult.none;

  static void dispose() => _subscription?.cancel();
}

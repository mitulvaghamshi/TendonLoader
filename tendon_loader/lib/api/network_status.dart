import 'dart:async' show StreamSubscription;

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatus {
  factory NetworkStatus() => _instance ??= NetworkStatus._();

  NetworkStatus._() {
    _subscription = Connectivity().onConnectivityChanged.listen((value) {
      _connections = value.takeWhile((r) {
        return r == .wifi || r == .mobile || r == .ethernet;
      });
    });
  }

  static NetworkStatus? _instance;
  static NetworkStatus get instance => NetworkStatus();

  late final StreamSubscription _subscription;

  Iterable<ConnectivityResult> _connections = const .empty();
  static bool get isConnected => instance._connections.isNotEmpty;

  void dispose() => _subscription.cancel();
}

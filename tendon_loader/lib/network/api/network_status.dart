import 'dart:async' show StreamSubscription;

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatus {
  factory NetworkStatus() => instance;

  NetworkStatus._() {
    _subscription = Connectivity().onConnectivityChanged.listen(_f);
  }

  static final instance = NetworkStatus._();

  late final StreamSubscription _subscription;

  Iterable<ConnectivityResult> _connections = const .empty();

  static bool get isConnected => instance._connections.isNotEmpty;

  void _f(Iterable<ConnectivityResult> results) {
    _connections = results.where(
      (r) => r == .wifi || r == .mobile || r == .ethernet,
    );
  }

  void dispose() => _subscription.cancel();
}

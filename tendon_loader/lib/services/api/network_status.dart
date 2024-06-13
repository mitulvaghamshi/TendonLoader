import 'dart:async' show StreamSubscription;

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatus {
  factory NetworkStatus() => instance;

  NetworkStatus._() {
    _subscription = Connectivity().onConnectivityChanged.listen((value) {
      _connections = value.takeWhile((result) =>
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet);
    });
  }

  static final NetworkStatus _instance = NetworkStatus._();
  static NetworkStatus get instance => _instance;

  Iterable<ConnectivityResult> _connections = const Iterable.empty();
  bool get isConnected => _connections.isNotEmpty;

  late final StreamSubscription _subscription;

  void dispose() => _subscription.cancel();
}

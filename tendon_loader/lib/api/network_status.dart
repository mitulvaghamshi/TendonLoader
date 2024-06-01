import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

final class NetworkStatus extends ChangeNotifier {
  factory NetworkStatus() => _instance ??= NetworkStatus._();

  NetworkStatus._() {
    Connectivity()
        .onConnectivityChanged
        .listen((value) => _result = value.first);
  }

  static NetworkStatus? _instance;

  ConnectivityResult _result = ConnectivityResult.none;

  static bool get isConnected => _instance?._result != ConnectivityResult.none;
}

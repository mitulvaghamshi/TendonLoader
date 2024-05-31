import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

final class NetworkStatus extends ChangeNotifier {
  factory NetworkStatus() => _instace ??= NetworkStatus._();

  NetworkStatus._() {
    Connectivity()
        .onConnectivityChanged
        .listen((value) => _result = value.first);
  }

  static NetworkStatus? _instace;

  static ConnectivityResult _result = ConnectivityResult.none;

  static bool get isConnected =>
      NetworkStatus._result != ConnectivityResult.none;
}

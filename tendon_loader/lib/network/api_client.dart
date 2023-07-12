import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

@immutable
mixin ApiClient {
  static const _host = '192.168.0.113:5082';
  static const _headers = {'Accept': 'application/json'};

  static Future<(dynamic, bool)> get(final String path) async {
    try {
      final res = await http.get(Uri.http(_host, path), headers: _headers);
      if (res.statusCode == 200) {
        return (jsonDecode(res.body), false);
      } else if (res.statusCode == 404) {
        return (null, true);
      }
    } on HttpException {
      return (null, true);
    }
    return (null, true);
  }

  // TODO(me): Implement post/upload...
  Future<void> post() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) return;
  }
}

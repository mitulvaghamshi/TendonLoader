import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// http://192.168.0.113:5082/index.html
@immutable
mixin ApiClient {
  static const _host = '192.168.0.113:5082';
  static const _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  /// @param `path` - Network resource path.
  /// @return `Record<Json, HasError)` - Whether request succeed with data.
  static Future<(dynamic, bool)> get(final String path) async {
    if (!await isConnected()) return ('No Internet Connection.', true);
    try {
      final response = await http.get(
        Uri.http(_host, path),
        headers: _headers,
      );
      // TODO(me): Return error info, probably as Error model.
      return switch (response.statusCode) {
        200 => (jsonDecode(response.body), false),
        404 => ('[HTTP GET]:Resource not found', true),
        _ => ('[HTTP GET]:Something unknown happened', true),
      };
    } on HttpException {
      throw const HttpException('[HTTP GET]:Error sending request.');
    }
  }

  /// @param `path` - Network resource path.
  /// @return `Record<String, HasError)` - Whether request succeed with reason.
  static Future<(String, bool)> post(
    final String path,
    final Map<String, dynamic> data,
  ) async {
    if (!await isConnected()) return ('No Internet Connection.', true);
    try {
      final response = await http.post(
        Uri.http(_host, path),
        headers: _headers,
        body: jsonEncode(data),
      );

      // TODO(me): Return error info, probably as Error model.
      return switch (response.statusCode) {
        201 => ('[HTTP POST]:Content created', false),
        _ => ('[HTTP POST]:Something unknown happened', true),
      };
    } on HttpException {
      throw const HttpException('[HTTP POST]:Error sending request.');
    }
  }

  /// @param `path` - Network resource path.
  /// @return `Record<String, HasError)` - Whether request succeed with reason.
  static Future<(String, bool)> put(
    final String path,
    final Map<String, dynamic> data,
  ) async {
    if (!await isConnected()) return ('No Internet Connection.', true);
    try {
      final response = await http.put(
        Uri.http(_host, path),
        headers: _headers,
        body: jsonEncode(data),
      );
      // TODO(me): Return error info, probably as Error model.
      return switch (response.statusCode) {
        204 => ('[HTTP PUT]:No Content', false),
        400 => ('[HTTP PUT]:Bad request', true),
        _ => ('[HTTP PUT]:Something unknown happened', true),
      };
    } on HttpException {
      throw const HttpException('[HTTP PUT]:Error sending request.');
    }
  }

  static Future<(dynamic, bool)> delete(final String path) async {
    throw UnimplementedError('Delete not implemented.');
    // if (!await isConnected()) return ('No Internet Connection.', true);
    // try {
    //   final response = await http.delete(
    //     Uri.http(_host, path),
    //     headers: _headers,
    //   );
    //   if (response.statusCode == 204) {
    //     // No Content (Success)
    //     return (jsonDecode(response.body), false);
    //   } else if (response.statusCode == 400) {
    //     // Bad Request (Id didn't match)
    //     return (null, true);
    //   } else {
    //     return (null, true);
    //   }
    // } on HttpException {
    //   return (null, true);
    // }
  }

  static Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}

import 'dart:async' show Future;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show ContentType, HttpException, HttpHeaders, HttpStatus;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tendon_loader/api/network_status.dart';
import 'package:tendon_loader/api/snapshot.dart';

@immutable
mixin ApiClient {
  static const _host = String.fromEnvironment('API_HOST');
  static final _headers = {
    HttpHeaders.acceptHeader: ContentType.json.value,
    HttpHeaders.contentTypeHeader: ContentType.json.value,
  };
}

extension Utils on ApiClient {
  Future<Snapshot> get<T>(String path) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!NetworkStatus.instance.isConnected) {
      return const Snapshot.withError('No connection.');
    }
    try {
      final res = await http.get(
        Uri.http(ApiClient._host, path),
        headers: ApiClient._headers,
      );
      if (res.statusCode == HttpStatus.ok) {
        return Snapshot.withData(jsonDecode(res.body));
      }
      return Snapshot.withError(res.reasonPhrase.toString());
    } on HttpException catch (e) {
      return Snapshot.withError(e.message);
    }
  }

  Future<Snapshot> post<T>(String path, Map<String, dynamic> data) async {
    if (!NetworkStatus.instance.isConnected) {
      return const Snapshot.withError('No connection.');
    }
    try {
      final res = await http.post(
        Uri.http(ApiClient._host, path),
        headers: ApiClient._headers,
        body: jsonEncode(data),
      );
      if (res.statusCode == HttpStatus.ok) {
        return Snapshot.withData(jsonDecode(res.body));
      }
      return Snapshot.withError(res.reasonPhrase.toString());
    } on HttpException catch (e) {
      return Snapshot.withError(e.message);
    }
  }

  Future<Snapshot> put<T>(String path, Map<String, dynamic> data) async {
    if (!NetworkStatus.instance.isConnected) {
      return const Snapshot.withError('No connection.');
    }
    try {
      final res = await http.put(
        Uri.http(ApiClient._host, path),
        headers: ApiClient._headers,
        body: jsonEncode(data),
      );
      if (res.statusCode == HttpStatus.noContent) {
        return const Snapshot.nothing();
      }
      return Snapshot.withError(res.reasonPhrase.toString());
    } on HttpException catch (e) {
      return Snapshot.withError(e.message);
    }
  }

  Future<Snapshot> delete<T>(String path) async {
    if (!NetworkStatus.instance.isConnected) {
      return const Snapshot.withError('No connection.');
    }
    try {
      final res = await http.delete(
        Uri.http(ApiClient._host, path),
        headers: ApiClient._headers,
      );
      if (res.statusCode == HttpStatus.noContent) {
        return const Snapshot.nothing();
      }
      return Snapshot.withError(res.reasonPhrase.toString());
    } on HttpException catch (e) {
      return Snapshot.withError(e.message);
    }
  }
}

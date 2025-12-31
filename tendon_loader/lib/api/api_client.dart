import 'dart:async' show Future;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show ContentType, HttpException, HttpHeaders, HttpStatus;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tendon_loader/api/network_status.dart';
import 'package:tendon_loader/api/snapshot.dart';

typedef R<T> = Snapshot<T>;

@immutable
mixin ApiClient {
  static const host = String.fromEnvironment('API_HOST');
  static final _headers = {
    HttpHeaders.acceptHeader: ContentType.json.value,
    HttpHeaders.contentTypeHeader: ContentType.json.value,
  };
}

extension on ApiClient {
  Future<R<T>> _ifConnected<T>(AsyncValueGetter<R<T>> request) async {
    if (kDebugMode) {
      await Future<void>.delayed(const Duration(seconds: 2));
    }
    if (!NetworkStatus.isConnected) {
      return const .error('No connection');
    }
    try {
      return await request();
    } on http.ClientException {
      return const .error('Unable to connect to the server!');
    } on HttpException catch (e) {
      return .error(e.message);
    }
  }
}

extension Utils on ApiClient {
  Future<R<T>> get<T>(String path) async => _ifConnected(() async {
    final res = await http.get(
      .http(ApiClient.host, path),
      headers: ApiClient._headers,
    );
    if (res.statusCode == HttpStatus.ok) {
      return .data(jsonDecode(res.body));
    }
    return .error(res.reasonPhrase);
  });

  Future<R<T>> post<T>(
    String path, {
    required Map<String, dynamic> values,
  }) async => _ifConnected(() async {
    final res = await http.post(
      .http(ApiClient.host, path),
      headers: ApiClient._headers,
      body: jsonEncode(values),
    );
    if (res.statusCode == HttpStatus.ok) {
      return .data(jsonDecode(res.body));
    }
    return .error(res.reasonPhrase);
  });

  Future<R<T>> put<T>(
    String path, {
    required Map<String, dynamic> values,
  }) async => _ifConnected(() async {
    final res = await http.put(
      .http(ApiClient.host, path),
      headers: ApiClient._headers,
      body: jsonEncode(values),
    );
    if (res.statusCode == HttpStatus.noContent) {
      return const .none();
    }
    return .error(res.reasonPhrase);
  });

  Future<R<T>> delete<T>(String path) async => _ifConnected(() async {
    final res = await http.delete(
      .http(ApiClient.host, path),
      headers: ApiClient._headers,
    );
    if (res.statusCode == HttpStatus.noContent) {
      return const .none();
    }
    return .error(res.reasonPhrase);
  });
}

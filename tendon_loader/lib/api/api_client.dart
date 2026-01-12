import 'dart:async' show Future, TimeoutException;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show ContentType, HttpException, HttpHeaders;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tendon_loader/api/network_status.dart';
import 'package:tendon_loader/api/snapshot.dart';

typedef R<T> = Snapshot<T>;
typedef Fn<T> = T Function(Object? data)?;

@immutable
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const host = String.fromEnvironment('API_HOST');
  static const _timeout = Duration(seconds: 5);
  static final _headers = {
    HttpHeaders.acceptHeader: ContentType.json.value,
    HttpHeaders.contentTypeHeader: ContentType.json.value,
  };
}

extension ApiClientExtension on ApiClient {
  Future<R<T>> get<T>(String path, {Fn<T>? fromJson}) => _send(
    () => _client.get(
      Uri.http(ApiClient.host, path),
      headers: ApiClient._headers,
    ),
    fromJson,
  );

  Future<R<T>> post<T>(
    String path, {
    required Map<String, dynamic> body,
    Fn<T>? fromJson,
  }) => _send(
    () => _client.post(
      Uri.http(ApiClient.host, path),
      headers: ApiClient._headers,
      body: jsonEncode(body),
    ),
    fromJson,
  );

  Future<R<T>> put<T>(
    String path, {
    required Map<String, dynamic> body,
    Fn<T>? fromJson,
  }) => _send(
    () => _client.put(
      Uri.http(ApiClient.host, path),
      headers: ApiClient._headers,
      body: jsonEncode(body),
    ),
    fromJson,
  );

  Future<R<T>> delete<T>(String path, {Fn<T>? fromJson}) => _send(
    () => _client.delete(
      Uri.http(ApiClient.host, path),
      headers: ApiClient._headers,
    ),
    fromJson,
  );
}

extension on ApiClient {
  Future<R<T>> _send<T>(
    Future<http.Response> Function() request,
    Fn<T>? fromJson,
  ) async => _ifConnected(() async {
    final res = await request().timeout(ApiClient._timeout);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return const .none();
      final data = jsonDecode(res.body);
      return .data(fromJson != null ? fromJson(data) : data);
    }
    return .error(res.reasonPhrase);
  });

  Future<R<T>> _ifConnected<T>(AsyncValueGetter<R<T>> request) async {
    if (kDebugMode) {
      await Future.delayed(const Duration(seconds: 2));
    }
    if (!NetworkStatus.isConnected) {
      return const .error('Check your connection!');
    }
    var delay = const Duration(milliseconds: 500);
    for (var i = 0; i < 3; i++) {
      try {
        return await request();
      } on http.ClientException {
        if (i == 2) return const .error('Unable to connect to the server!');
      } on HttpException catch (e) {
        if (i == 2) return .error(e.message);
      } on TimeoutException {
        if (i == 2) return const .error('Request Timed out!');
      }
      await Future.delayed(delay);
      delay *= 2;
    }
    return const .error('Something went wrong, try again!');
  }
}

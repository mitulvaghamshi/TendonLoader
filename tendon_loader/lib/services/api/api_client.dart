import 'dart:async' show Future;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show HttpException;

import 'package:http/http.dart' as http;
import 'package:tendon_loader/services/api/network_status.dart';
import 'package:tendon_loader/services/api/snapshot.dart';

abstract class ApiClient {
  const ApiClient();

  static const _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  static const _host = String.fromEnvironment('API_HOST');
  static const _networkError = Snapshot.withError('No Internet Connection');

  Future<Snapshot> get<T>(final String path) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!NetworkStatus.instance.isConnected) return _networkError;
    try {
      final response = await http.get(Uri.http(_host, path), headers: _headers);
      if (response.statusCode == 200) {
        return Snapshot.withData(jsonDecode(response.body));
      }
      return Snapshot.withError(response.reasonPhrase.toString());
    } on HttpException catch (e) {
      return Snapshot.withError(e.message);
    }
  }

  Future<Snapshot> post<T>(
    final String path,
    final Map<String, dynamic> data,
  ) async {
    if (!NetworkStatus.instance.isConnected) return _networkError;
    try {
      final response = await http.post(Uri.http(_host, path),
          headers: _headers, body: jsonEncode(data));
      if (response.statusCode == 201) {
        return const Snapshot.withData('Saved Successfully');
      }
      return Snapshot.withError(response.reasonPhrase.toString());
    } on HttpException catch (e) {
      return Snapshot.withError(e.message);
    }
  }

  Future<Snapshot> put<T>(
    final String path,
    final Map<String, dynamic> data,
  ) async {
    if (!NetworkStatus.instance.isConnected) return _networkError;
    try {
      final response = await http.put(Uri.http(_host, path),
          headers: _headers, body: jsonEncode(data));
      if (response.statusCode == 204) {
        return const Snapshot.withData('Saved Successfully');
      }
      return Snapshot.withError(response.reasonPhrase.toString());
    } on HttpException catch (e) {
      return Snapshot.withError(e.message);
    }
  }

  // TODO(mitul): Fix this...
  Future<Snapshot> delete<T>(final String path) async {
    if (!NetworkStatus.instance.isConnected) return _networkError;
    try {
      final response =
          await http.delete(Uri.http(_host, path), headers: _headers);
      if (response.statusCode == 204) {
        return const Snapshot.withData('Deleted Successfully');
      }
      return Snapshot.withError(response.reasonPhrase.toString());
    } on HttpException catch (e) {
      return Snapshot.withError(e.message);
    }
  }
}

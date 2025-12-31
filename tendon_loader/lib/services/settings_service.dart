import 'package:flutter/material.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/api/snapshot.dart';
import 'package:tendon_loader/models/settings.dart';

@immutable
class SettingsService with ApiClient {
  factory SettingsService() => instance;

  const SettingsService._();

  static const _instance = SettingsService._();
  static SettingsService get instance => _instance;
}

extension Utils on SettingsService {
  Future<Snapshot<Settings>> getSettingsBy({required int userId}) async {
    final snapshot = await get('settings/$userId');
    if (snapshot.requireData case List<dynamic> items) {
      return .data(.fromJson(items.single));
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<String>> createSettings(Settings settings) async {
    final snapshot = await post<String>('settings', values: settings.map);
    if (snapshot.hasData) {
      return .data(snapshot.requireData);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<Never>> updateSettings(Settings settings) async {
    final snapshot = await put('settings/${settings.id}', values: settings.map);
    if (snapshot.hasData) {
      return .data(snapshot.requireData);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<Never>> deleteSettingsById(int id) async {
    final snapshot = await delete('settings/$id');
    if (snapshot.hasData) {
      return .data(snapshot.requireData);
    }
    return .error(snapshot.error);
  }
}

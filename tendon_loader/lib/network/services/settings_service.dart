import 'package:api_server/api_server.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/network/api/api_client.dart';

@immutable
class SettingsService {
  factory SettingsService({ApiClient? client, LocalCache? cache}) =>
      client != null || cache != null
      ? ._(client ?? .new(), cache ?? .instance)
      : instance;

  const SettingsService._(this._client, this._cache);

  static final instance = SettingsService._(.new(), .instance);

  final ApiClient _client;
  final LocalCache _cache;

  Future<Snapshot<Settings>> getSettingsBy({required int userId}) async {
    if (_cache.settings.containsKey(userId)) {
      return .data(_cache.settings[userId]!);
    }
    final snapshot = await _client.get('settings/$userId');
    if (snapshot.data case List<dynamic> items) {
      final settings = Settings.fromJson(items.single);
      _cache.settings.update(userId, (_) => settings, ifAbsent: () => settings);
      return .data(settings);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<String>> createSettings(Settings s) async {
    if (s.userId != null) {
      _cache.settings.update(s.userId!, (_) => s, ifAbsent: () => s);
    }
    final snapshot = await _client.post('settings', body: s.map);
    return snapshot.hasData
        ? .data(snapshot.requireData)
        : .error(snapshot.error);
  }

  Future<Snapshot<Never>> updateSettings(Settings s) async {
    if (s.userId != null && _cache.settings.containsKey(s.userId)) {
      _cache.settings.update(s.userId!, (_) => s);
    }
    final snapshot = await _client.put('settings/${s.id}', body: s.map);
    return snapshot.hasData
        ? .data(snapshot.requireData)
        : .error(snapshot.error);
  }

  Future<Snapshot<Never>> deleteSettingsById({
    required int userId,
    required int settingsId,
  }) async {
    _cache.settings.remove(userId);
    final snapshot = await _client.delete('settings/$settingsId');
    return snapshot.hasData
        ? .data(snapshot.requireData)
        : .error(snapshot.error);
  }
}

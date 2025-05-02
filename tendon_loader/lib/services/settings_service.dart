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
  Future<Snapshot<Settings>> getSettingsBy({int? userId}) async {
    if (userId == null) {
      return const Snapshot.withError('User id Opps!');
    }
    final snapshot = await get('settings/$userId');
    if (snapshot.data case List<dynamic> items) {
      return Snapshot.withData(Settings.fromJson(items.single));
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> createSettings(Settings settings) async {
    final snapshot = await post<String>('settings', settings.json);
    if (snapshot.hasData) {
      return Snapshot.withData(snapshot.requireData);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> updateSettings(Settings settings) async {
    final snapshot = await put('settings/${settings.id}', settings.json);
    if (snapshot.hasData) {
      return Snapshot.withData(snapshot.requireData);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> deleteSettingsById(int id) async {
    final snapshot = await delete('settings/$id');
    if (snapshot.hasData) {
      return Snapshot.withData(snapshot.requireData);
    }
    return Snapshot.withError(snapshot.error);
  }
}

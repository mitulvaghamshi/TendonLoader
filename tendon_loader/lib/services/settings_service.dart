import 'package:flutter/material.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/api/snapshot.dart';
import 'package:tendon_loader/models/settings.dart';

@immutable
class SettingsService extends ApiClient {
  factory SettingsService() => const SettingsService._();

  const SettingsService._();

  static final SettingsService _instance = SettingsService();
  static SettingsService get instance => _instance;

  Future<Snapshot<Settings>> getSettingsByUserId(final int? id) async {
    if (id == null) return const Snapshot.withError('User Id is null');
    final snapshot = await get('settings/$id');
    if (snapshot.hasData) {
      final settings = Settings.fromJson(snapshot.requireData);
      return Snapshot.withData(settings);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> createSettings(final Settings settings) async {
    final snapshot = await post<String>('settings', settings.json);
    if (snapshot.hasData) return Snapshot.withData(snapshot.requireData);
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> updateSettings(final Settings settings) async {
    final snapshot = await put('settings/${settings.id}', settings.json);
    if (snapshot.hasData) return Snapshot.withData(snapshot.requireData);
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> deleteSettingsById({required final int id}) async {
    final snapshot = await delete('settings/$id');
    if (snapshot.hasData) return Snapshot.withData(snapshot.requireData);
    return Snapshot.withError(snapshot.error);
  }
}

import 'package:flutter/material.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/services/api/api_client.dart';
import 'package:tendon_loader/services/api/snapshot.dart';

@immutable
class SettingsService extends ApiClient {
  Future<Snapshot<Settings>> getBy({required final int userId}) async {
    final snapshot = await get('settings/$userId');
    if (snapshot.hasData) {
      return Snapshot.withData(Settings.fromJson(snapshot.requireData));
    }
    return Snapshot.withError(snapshot.error.toString());
  }

  Future<Snapshot> create(final Settings settings) async {
    final snapshot = await post<String>('settings', settings.json);
    if (snapshot.hasData) {
      return Snapshot.withData(snapshot.requireData);
    }
    return Snapshot.withError(snapshot.error.toString());
  }

  Future<Snapshot> update(final Settings settings) async {
    final snapshot = await put('settings/${settings.id}', settings.json);
    if (snapshot.hasData) {
      return Snapshot.withData(snapshot.requireData);
    }
    return Snapshot.withError(snapshot.error.toString());
  }

  Future<Snapshot> deleteBy({required final int id}) async {
    final snapshot = await delete('settings/$id');
    if (snapshot.hasData) {
      return Snapshot.withData(snapshot.requireData);
    }
    return Snapshot.withError(snapshot.error.toString());
  }
}

import 'package:flutter/material.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/services/api/api_client.dart';

@immutable
final class SettingsService extends ApiClient {
  Future<Settings> getBy({required final int userId}) async {
    final snapshot = await get('settings/$userId');
    if (snapshot.hasError) {
      debugPrint(snapshot.error.toString());
      throw 'Unable to load Settings.';
    }
    return Settings.fromJson(snapshot.requireData);
  }

  Future<void> create(final Settings settings) async {
    final snapshot = await post<String>('settings', settings.json);
    if (snapshot.hasError) {
      debugPrint(snapshot.error.toString());
      throw 'Unable to create Settings or already exists.';
    }
    debugPrint(snapshot.requireData);
  }

  Future<void> update(final Settings settings) async {
    final snapshot = await put('settings/${settings.id}', settings.json);
    if (snapshot.hasError) {
      debugPrint(snapshot.error.toString());
      throw 'Unable to update Settings.';
    }
    debugPrint(snapshot.requireData);
  }

  Future<void> deleteBy({required final int id}) async {
    final snapshot = await delete('settings/$id');
    if (snapshot.hasError) {
      debugPrint(snapshot.error.toString());
      throw 'Unable to delete Settings.';
    }
    debugPrint(snapshot.requireData);
  }
}

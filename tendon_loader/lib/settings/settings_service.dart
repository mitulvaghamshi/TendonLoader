import 'package:flutter/material.dart';
import 'package:tendon_loader/network/api_client.dart';
import 'package:tendon_loader/settings/settings.dart';

@immutable
mixin SettingsService {
  static Future<Settings> get({required final int userId}) async {
    final (json, error) = await ApiClient.get('settings/$userId');
    if (error) throw 'Unable to load Settings.';
    return Settings.fromJson(json);
  }

  static Future<void> create(final Settings settings) async {
    final (json, error) = await ApiClient.post('settings', settings.json);
    if (error) throw 'Unable to create Settings or already exists.';
    print(json);
  }

  static Future<void> update(final Settings settings) async {
    final (_, error) =
        await ApiClient.put('settings/${settings.id}', settings.json);
    if (error) throw 'Unable to update Settings.';
  }

  static Future<void> delete({required final int id}) async {
    final (json, error) = await ApiClient.delete('settings/$id');
    if (error) throw 'Unable to delete Settings.';
    print(json);
  }
}

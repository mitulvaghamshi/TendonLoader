import 'package:flutter/material.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/models/settings.dart';

@immutable
mixin SettingsService {
  static Future<Settings> get({required final int userId}) async {
    final result = await ApiClient.get('settings/$userId');
    if (result.hasError) {
      debugPrint(result.error!.message);
      throw 'Unable to load Settings.';
    }
    return Settings.fromJson(result.data!.content);
  }

  static Future<void> create(final Settings settings) async {
    final result = await ApiClient.post('settings', settings.json);
    if (result.hasError) {
      debugPrint(result.error!.message);
      throw 'Unable to create Settings or already exists.';
    }
    debugPrint(result.data!.content);
  }

  static Future<void> update(final Settings settings) async {
    final result =
        await ApiClient.put('settings/${settings.id}', settings.json);
    if (result.hasError) {
      debugPrint(result.error!.message);
      throw 'Unable to update Settings.';
    }
    debugPrint(result.data!.content);
  }

  static Future<void> delete({required final int id}) async {
    final result = await ApiClient.delete('settings/$id');
    if (result.hasError) {
      debugPrint(result.error!.message);
      throw 'Unable to delete Settings.';
    }
    debugPrint(result.data!.content);
  }
}

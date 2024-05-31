import 'package:flutter/material.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/models/prescription.dart';

@immutable
mixin PrescriptionService {
  static final Map<int, Prescription> _cache = {};

  static Future<Prescription> get({required final int id}) async {
    if (_cache.containsKey(id)) return _cache[id]!;
    final result = await ApiClient.get('prescription/$id');
    if (result.hasError) {
      debugPrint(result.error!.message);
      throw 'Requested resource not found.';
    }
    return _cache.putIfAbsent(id, () {
      return Prescription.fromJson(result.data!.content);
    });
  }

  static Future<void> create(final Prescription prescription) async {
    final result = await ApiClient.post('prescription', prescription.json);
    if (result.hasError) {
      debugPrint(result.error!.message);
      throw 'Unable to create Prescription or already exists.';
    }
    debugPrint(result.data!.content);
  }

  static Future<void> update(final Prescription prescription) async {
    if (_cache.containsKey(prescription.id)) {
      _cache.update(prescription.id!, (_) => prescription);
    }
    final result = await ApiClient.put(
      'prescription/${prescription.id}',
      prescription.json,
    );
    if (result.hasError) {
      debugPrint(result.error!.message);
      throw 'Unable to update Prescription.';
    }
    debugPrint(result.data!.content);
  }

  static Future<void> delete({required final int id}) async {
    if (_cache.containsKey(id)) _cache.remove(id);
    final result = await ApiClient.delete('prescription/$id');
    if (result.hasError) {
      debugPrint(result.error!.message);
      throw 'Unable to delete Prescription.';
    }
    debugPrint(result.data!.content);
  }
}

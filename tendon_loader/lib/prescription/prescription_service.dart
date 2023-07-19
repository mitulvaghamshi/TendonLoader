import 'package:flutter/material.dart';
import 'package:tendon_loader/network/api_client.dart';
import 'package:tendon_loader/prescription/prescription.dart';

@immutable
mixin PrescriptionService {
  static final Map<int, Prescription> _cache = {};

  static Future<Prescription> get({required final int id}) async {
    if (_cache.containsKey(id)) return _cache[id]!;
    final (json, hasError) = await ApiClient.get('prescription/$id');
    if (hasError) return throw 'Not found';
    return _cache.putIfAbsent(id, () => Prescription.fromJson(json));
  }

  static Future<void> create(final Prescription prescription) async {
    final (json, error) =
        await ApiClient.post('prescription', prescription.json);
    if (error) throw 'Unable to create Prescription or already exists.';
    print(json);
  }

  static Future<void> update(final Prescription prescription) async {
    if (_cache.containsKey(prescription.id)) {
      _cache.update(prescription.id!, (_) => prescription);
    }
    final (_, error) = await ApiClient.put(
        'prescription/${prescription.id}', prescription.json);
    if (error) throw 'Unable to update Prescription.';
  }

  static Future<void> delete({required final int id}) async {
    if (_cache.containsKey(id)) _cache.remove(id);
    final (json, error) = await ApiClient.delete('prescription/$id');
    if (error) throw 'Unable to delete Prescription.';
    print(json);
  }
}

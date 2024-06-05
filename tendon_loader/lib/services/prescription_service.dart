import 'package:flutter/material.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/services/api/api_client.dart';

@immutable
class PrescriptionService extends ApiClient {
  static final Map<int, Prescription> _cache = {};

  Future<Prescription> getBy({required final int id}) async {
    if (_cache.containsKey(id)) return _cache[id]!;
    final result = await get('prescription/$id');
    if (result.hasError) {
      debugPrint(result.error.toString());
      throw 'Requested resource not found.';
    }
    return _cache.putIfAbsent(
        id, () => Prescription.fromJson(result.requireData));
  }

  Future<void> create(final Prescription prescription) async {
    final result = await post('prescription', prescription.json);
    if (result.hasError) {
      debugPrint(result.error.toString());
      throw 'Unable to create Prescription or already exists.';
    }
    debugPrint(result.requireData);
  }

  Future<void> update(final Prescription prescription) async {
    if (_cache.containsKey(prescription.id)) {
      _cache.update(prescription.id!, (_) => prescription);
    }
    final result =
        await put('prescription/${prescription.id}', prescription.json);
    if (result.hasError) {
      debugPrint(result.error.toString());
      throw 'Unable to update Prescription.';
    }
    debugPrint(result.requireData);
  }

  Future<void> deleteBy({required final int id}) async {
    if (_cache.containsKey(id)) _cache.remove(id);
    final result = await delete('prescription/$id');
    if (result.hasError) {
      debugPrint(result.error.toString());
      throw 'Unable to delete Prescription.';
    }
    debugPrint(result.requireData);
  }
}

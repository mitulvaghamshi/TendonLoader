import 'package:flutter/material.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/api/snapshot.dart';
import 'package:tendon_loader/models/prescription.dart';

@immutable
class PrescriptionService extends ApiClient {
  factory PrescriptionService() => const PrescriptionService._();

  const PrescriptionService._();

  static final PrescriptionService _instance = PrescriptionService();
  static PrescriptionService get instance => _instance;

  static final Map<int, Prescription> _cache = {};

  Future<Snapshot<Prescription>> getPrescriptionById(final int? id) async {
    if (id == null) return const Snapshot.withError('Prescription Id is null');
    if (_cache.containsKey(id)) return Snapshot.withData(_cache[id]!);
    final snapshot = await get('prescription/$id');
    if (snapshot.hasData) {
      final prescription = Prescription.fromJson(snapshot.requireData);
      _cache.putIfAbsent(id, () => prescription);
      return Snapshot.withData(prescription);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> createPrescription(final Prescription prescription) async {
    final snapshot = await post('prescription', prescription.json);
    if (snapshot.hasData) return Snapshot.withData(snapshot.requireData);
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> updatePrescription(final Prescription prescription) async {
    if (_cache.containsKey(prescription.id)) {
      _cache.update(prescription.id!, (_) => prescription);
    }
    final snapshot =
        await put('prescription/${prescription.id}', prescription.json);
    if (snapshot.hasData) return Snapshot.withData(snapshot.requireData);
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> deletePrescriptionById(final int id) async {
    if (_cache.containsKey(id)) _cache.remove(id);
    final snapshot = await delete('prescription/$id');
    if (snapshot.hasData) return Snapshot.withData(snapshot.requireData);
    return Snapshot.withError(snapshot.error);
  }
}

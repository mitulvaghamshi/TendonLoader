import 'package:flutter/material.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/api/snapshot.dart';
import 'package:tendon_loader/models/prescription.dart';

@immutable
class PrescriptionService with ApiClient {
  factory PrescriptionService() => instance;

  const PrescriptionService._();

  static const _instance = PrescriptionService._();
  static PrescriptionService get instance => _instance;

  static final Map<int, Prescription> _cache = {};
}

extension Utils on PrescriptionService {
  Future<Snapshot<Prescription>> getPrescriptionById(int? id) async {
    if (id == null) {
      return const .error('Please provide prescription id.');
    }
    if (PrescriptionService._cache.containsKey(id)) {
      return .data(PrescriptionService._cache[id]!);
    }
    final snapshot = await get('prescription/$id');
    if (snapshot.hasData) {
      final items = List<Map<String, dynamic>>.from(snapshot.requireData);
      final prescription = items.map(Prescription.fromJson).single;
      PrescriptionService._cache.putIfAbsent(id, () => prescription);
      return .data(prescription);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<Never>> createPrescription(Prescription prescription) async {
    final snapshot = await post('prescription', values: prescription.map);
    if (snapshot.hasData) {
      return .data(snapshot.requireData);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<Never>> updatePrescription(Prescription prescription) async {
    if (PrescriptionService._cache.containsKey(prescription.id)) {
      PrescriptionService._cache.update(prescription.id!, (_) => prescription);
    }
    final snapshot = await put(
      'prescription/${prescription.id}',
      values: prescription.map,
    );
    if (snapshot.hasData) {
      return .data(snapshot.requireData);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<Never>> deletePrescriptionById(int id) async {
    if (PrescriptionService._cache.containsKey(id)) {
      PrescriptionService._cache.remove(id);
    }
    final snapshot = await delete('prescription/$id');
    if (snapshot.hasData) {
      return .data(snapshot.requireData);
    }
    return .error(snapshot.error);
  }
}

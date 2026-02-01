import 'package:api_server/api_server.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/network/api/api_client.dart';

@immutable
class PrescriptionService {
  factory PrescriptionService({ApiClient? client, LocalCache? cache}) =>
      client != null || cache != null
      ? ._(client ?? .new(), cache ?? .instance)
      : instance;

  const PrescriptionService._(this._client, this._cache);

  static final instance = PrescriptionService._(.new(), .instance);

  final ApiClient _client;
  final LocalCache _cache;

  Future<Snapshot<Prescription>> getPrescriptionById(int? id) async {
    if (id == null) return const .error('Please provide prescription id.');
    if (_cache.prescriptions.containsKey(id)) {
      return .data(_cache.prescriptions[id]!);
    }
    final snapshot = await _client.get('prescription/$id');
    if (snapshot.data case List<dynamic> items) {
      final prescription = Prescription.fromJson(items.single);
      _cache.prescriptions.putIfAbsent(id, () => prescription);
      return .data(prescription);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<Never>> createPrescription(Prescription p) async {
    final snapshot = await _client.post('prescription', body: p.map);
    return snapshot.hasData
        ? .data(snapshot.requireData)
        : .error(snapshot.error);
  }

  Future<Snapshot<Never>> updatePrescription(Prescription p) async {
    if (_cache.prescriptions.containsKey(p.id)) {
      _cache.prescriptions.update(p.id!, (_) => p);
    }
    final snapshot = await _client.put('prescription/${p.id}', body: p.map);
    return snapshot.hasData
        ? .data(snapshot.requireData)
        : .error(snapshot.error);
  }

  Future<Snapshot<Never>> deletePrescriptionById(int id) async {
    if (_cache.prescriptions.containsKey(id)) _cache.prescriptions.remove(id);
    final snapshot = await _client.delete('prescription/$id');
    return snapshot.hasData
        ? .data(snapshot.requireData)
        : .error(snapshot.error);
  }
}

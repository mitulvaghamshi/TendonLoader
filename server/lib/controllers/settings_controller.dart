import 'dart:convert';

import 'package:server/services/settings_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class SettingsController {
  const SettingsController(this.service);

  final SettingsService service;

  Response queryHandler(Request request) =>
      .ok(jsonEncode(service.selectAll()));

  Response selectHandler(Request request) {
    if (request.params case {'id': String? id}) {
      return .ok(jsonEncode(service.selectByUser(id)));
    }
    return .badRequest();
  }

  Response searchHandler(Request request) {
    if (request.params case {'term': String term}) {
      return .ok(jsonEncode(service.search(term)));
    }
    return .badRequest();
  }

  Future<Response> insertHandler(Request request) async {
    final body = await request.readAsString();
    if (jsonDecode(body) case {
      'user_id': int? userId,
      'prescription_id': int? prescriptionId,
      'dark_mode': bool darkMode,
      'auto_upload': bool autoUpload,
      'editable_prescription': bool editablePrescription,
      'graph_scale': num graphScale,
    }) {
      service.insert(
        userId: userId,
        prescriptionId: prescriptionId,
        darkMode: darkMode,
        autoUpload: autoUpload,
        editablePrescription: editablePrescription,
        graphScale: graphScale.toDouble(),
      );
      return .ok(0);
    }
    return .badRequest();
  }

  Future<Response> updateHandler(Request request) async {
    if (request.params case {'id': String id}) {
      final body = await request.readAsString();
      if (jsonDecode(body) case {
        'user_id': int? userId,
        'prescription_id': int? prescriptionId,
        'dark_mode': bool darkMode,
        'auto_upload': bool autoUpload,
        'editable_prescription': bool editablePrescription,
        'graph_scale': num graphScale,
      }) {
        service.update(
          id: int.parse(id),
          userId: userId,
          prescriptionId: prescriptionId,
          darkMode: darkMode,
          autoUpload: autoUpload,
          editablePrescription: editablePrescription,
          graphScale: graphScale.toDouble(),
        );
        return .ok(0);
      }
    }
    return .badRequest();
  }

  Future<Response> deleteHandler(Request request) async {
    if (request.params case {'id': String id}) {
      service.delete(int.parse(id));
      return .ok(0);
    }
    return .badRequest();
  }
}

import 'dart:convert';

import 'package:server/services/settings_service.dart' as settings;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Response queryHandler(Request request) => .ok(jsonEncode(settings.selectAll));

Response selectHandler(Request request) {
  if (request.params case {'id': String? id}) {
    return .ok(jsonEncode(settings.selectByUser(id)));
  }
  return .badRequest();
}

Response searchHandler(Request request) {
  if (request.params case {'term': String term}) {
    return .ok(jsonEncode(settings.search(term)));
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
    settings.insert(
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
      settings.update(
        id: .parse(id),
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
    settings.delete(.parse(id));
    return .ok(0);
  }
  return .badRequest();
}

import 'dart:convert';

import 'package:server/services/settings_service.dart' as settings;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Response queryHandler(Request request) =>
    Response.ok(jsonEncode(settings.selectAll));

Response selectHandler(Request request) {
  final id = request.params['id'];
  if (id == null) {
    return Response.badRequest();
  }
  return Response.ok(jsonEncode(settings.selectByUser(id)));
}

Response searchHandler(Request request) {
  final term = request.params['term'];
  if (term == null) {
    return Response.badRequest();
  }
  return Response.ok(jsonEncode(settings.search(term)));
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
    return Response.ok(0);
  }
  return Response.badRequest();
}

Future<Response> updateHandler(Request request) async {
  final id = int.tryParse(request.params['id'].toString());
  if (id == null) {
    return Response.badRequest();
  }
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
      id: id,
      userId: userId,
      prescriptionId: prescriptionId,
      darkMode: darkMode,
      autoUpload: autoUpload,
      editablePrescription: editablePrescription,
      graphScale: graphScale.toDouble(),
    );
    return Response.ok(0);
  }
  return Response.badRequest();
}

Future<Response> deleteHandler(Request request) async {
  final id = int.tryParse(request.params['id'].toString());
  if (id == null) {
    return Response.badRequest();
  }
  settings.delete(id);
  return Response.ok(0);
}

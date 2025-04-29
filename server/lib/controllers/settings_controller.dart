import 'dart:convert';

import 'package:server/services/settings_service.dart';
import 'package:server/statements/settings_statements.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

extension SettingsController on SettingsStatements {
  Response queryHandler(Request request) => Response.ok(jsonEncode(selectAll));

  Response selectHandler(Request request) {
    final id = request.params['id'];
    if (id == null) return Response.badRequest(body: 'Invalid request\n');
    return Response.ok(jsonEncode(selectByUser(id)));
  }

  Response searchHandler(Request request) {
    final term = request.params['term'];
    if (term == null) return Response.badRequest(body: 'Invalid request\n');
    return Response.ok(jsonEncode(search(term)));
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
      insert(
        userId: userId,
        prescriptionId: prescriptionId,
        darkMode: darkMode,
        autoUpload: autoUpload,
        editablePrescription: editablePrescription,
        graphScale: graphScale.toDouble(),
      );
      return Response.ok('Inserted successfully');
    }
    return Response.badRequest(body: 'Invalid request body');
  }

  Future<Response> updateHandler(Request request) async {
    final id = int.tryParse(request.params['id'].toString());
    if (id == null) return Response.badRequest(body: 'Invalid request');
    final body = await request.readAsString();
    if (jsonDecode(body) case {
      'user_id': int? userId,
      'prescription_id': int? prescriptionId,
      'dark_mode': bool darkMode,
      'auto_upload': bool autoUpload,
      'editable_prescription': bool editablePrescription,
      'graph_scale': num graphScale,
    }) {
      update(
        id: id,
        userId: userId,
        prescriptionId: prescriptionId,
        darkMode: darkMode,
        autoUpload: autoUpload,
        editablePrescription: editablePrescription,
        graphScale: graphScale.toDouble(),
      );
      return Response.ok('Updated successfully');
    }
    return Response.badRequest(body: 'Invalid request body');
  }

  Future<Response> deleteHandler(Request request) async {
    final id = int.tryParse(request.params['id'].toString());
    if (id == null) return Response.badRequest(body: 'Invalid request');
    delete(id);
    return Response.ok('Deleted successfully');
  }
}

import 'dart:convert';

import 'package:server/services/prescription_service.dart' as prescription;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Response queryHandler(Request request) =>
    Response.ok(jsonEncode(prescription.selectAll));

Response selectHandler(Request request) {
  final id = int.tryParse(request.params['id'].toString());
  if (id == null) {
    return Response.badRequest();
  }
  return Response.ok(jsonEncode(prescription.selectBy(id)));
}

Response searchHandler(Request request) {
  final term = request.params['term'];
  if (term == null) {
    return Response.badRequest();
  }
  return Response.ok(jsonEncode(prescription.search(term)));
}

Future<Response> insertHandler(Request request) async {
  final body = await request.readAsString();
  if (jsonDecode(body) case {
    'reps': int reps,
    'sets': int sets,
    'set_rest': int setRest,
    'hold_time': int holdTime,
    'rest_time': int restTime,
    'mvc_duration': int mvcDuration,
    'target_load': num targetLoad,
  }) {
    prescription.insert(
      sets: sets,
      reps: reps,
      setRest: setRest,
      holdTime: holdTime,
      restTime: restTime,
      mvcDuration: mvcDuration,
      targetLoad: targetLoad.toDouble(),
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
    'reps': int reps,
    'sets': int sets,
    'set_rest': int setRest,
    'hold_time': int holdTime,
    'rest_time': int restTime,
    'mvc_duration': int mvcDuration,
    'target_load': num targetLoad,
  }) {
    prescription.update(
      id: id,
      sets: sets,
      reps: reps,
      setRest: setRest,
      holdTime: holdTime,
      restTime: restTime,
      mvcDuration: mvcDuration,
      targetLoad: targetLoad.toDouble(),
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
  prescription.delete(id);
  return Response.ok(0);
}

import 'dart:convert';

import 'package:server/services/prescription_service.dart';
import 'package:server/statements/prescription_statements.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

extension PrescriptionController on PrescriptionStatements {
  Response queryHandler(Request request) => Response.ok(jsonEncode(selectAll));

  Response selectHandler(Request request) {
    final id = int.tryParse(request.params['id'].toString());
    if (id == null) return Response.badRequest(body: 'Invalid request\n');
    return Response.ok(jsonEncode(selectBy(id)));
  }

  Response searchHandler(Request request) {
    final term = request.params['term'];
    if (term == null) return Response.badRequest(body: 'Invalid request\n');
    return Response.ok(jsonEncode(search(term)));
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
      insert(
        sets: sets,
        reps: reps,
        setRest: setRest,
        holdTime: holdTime,
        restTime: restTime,
        mvcDuration: mvcDuration,
        targetLoad: targetLoad.toDouble(),
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
      'reps': int reps,
      'sets': int sets,
      'set_rest': int setRest,
      'hold_time': int holdTime,
      'rest_time': int restTime,
      'mvc_duration': int mvcDuration,
      'target_load': num targetLoad,
    }) {
      update(
        id: id,
        sets: sets,
        reps: reps,
        setRest: setRest,
        holdTime: holdTime,
        restTime: restTime,
        mvcDuration: mvcDuration,
        targetLoad: targetLoad.toDouble(),
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

import 'dart:convert';

import 'package:server/services/exercise_service.dart';
import 'package:server/statements/exercise_statements.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

extension ExerciseController on ExerciseStatements {
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
      'user_id': int userId,
      'prescription_id': int? prescriptionId,
      'pain_score': num painScore,
      'datetime': String datetime,
      'tolerable': String tolerable,
      'completed': int /* bool */ completed,
      'progressor_id': String progressorId,
      'mvc_value': double? mvcValue,
      'data': String data,
    }) {
      insert(
        userId: userId,
        painScore: painScore.toDouble(),
        datetime: datetime,
        tolerable: tolerable,
        completed: completed,
        progressorId: progressorId,
        prescriptionId: prescriptionId,
        mvcValue: mvcValue,
        data: data,
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
      'user_id': int userId,
      'prescription_id': int? prescriptionId,
      'pain_score': num painScore,
      'datetime': String datetime,
      'tolerable': String tolerable,
      'completed': int /* bool */ completed,
      'progressor_id': String progressorId,
      'mvc_value': double? mvcValue,
      'data': String data,
    }) {
      update(
        id: id,
        userId: userId,
        painScore: painScore.toDouble(),
        datetime: datetime,
        tolerable: tolerable,
        completed: completed,
        progressorId: progressorId,
        prescriptionId: prescriptionId,
        mvcValue: mvcValue,
        data: data,
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

import 'dart:convert';

import 'package:server/services/exercise_service.dart' as exercise;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Response queryHandler(Request request) =>
    Response.ok(jsonEncode(exercise.selectAll));

Response selectHandler(Request request) {
  final id = int.tryParse(request.params['id'].toString());
  if (id == null) {
    return Response.badRequest();
  }
  return Response.ok(jsonEncode(exercise.selectBy(id)));
}

Response searchHandler(Request request) {
  final term = request.params['term'];
  if (term == null) {
    return Response.badRequest();
  }
  return Response.ok(jsonEncode(exercise.search(term)));
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
    exercise.insert(
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
    exercise.update(
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
    return Response.ok(0);
  }
  return Response.badRequest();
}

Future<Response> deleteHandler(Request request) async {
  final id = int.tryParse(request.params['id'].toString());
  if (id == null) {
    return Response.badRequest();
  }
  exercise.delete(id);
  return Response.ok(0);
}

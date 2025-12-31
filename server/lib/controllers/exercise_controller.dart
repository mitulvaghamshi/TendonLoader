import 'dart:convert';

import 'package:server/services/exercise_service.dart' as exercise;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Response queryHandler(Request request) => .ok(jsonEncode(exercise.selectAll));

Response selectHandler(Request request) {
  if (request.params case {'id': String id}) {
    return .ok(jsonEncode(exercise.selectBy(.parse(id))));
  }
  return .badRequest();
}

Response searchHandler(Request request) {
  if (request.params case {'term': String term}) {
    return .ok(jsonEncode(exercise.search(term)));
  }
  return .badRequest();
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
    'mvc_value': num? mvcValue,
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
      mvcValue: mvcValue?.toDouble(),
      data: data,
    );
    return .ok(0);
  }
  return .badRequest();
}

Future<Response> updateHandler(Request request) async {
  if (request.params case {'id': String id}) {
    final body = await request.readAsString();
    if (jsonDecode(body) case {
      'user_id': int userId,
      'prescription_id': int? prescriptionId,
      'pain_score': num painScore,
      'datetime': String datetime,
      'tolerable': String tolerable,
      'completed': int /* bool */ completed,
      'progressor_id': String progressorId,
      'mvc_value': num? mvcValue,
      'data': String data,
    }) {
      exercise.update(
        id: .parse(id),
        userId: userId,
        painScore: painScore.toDouble(),
        datetime: datetime,
        tolerable: tolerable,
        completed: completed,
        progressorId: progressorId,
        prescriptionId: prescriptionId,
        mvcValue: mvcValue?.toDouble(),
        data: data,
      );
      return .ok(0);
    }
  }
  return .badRequest();
}

Future<Response> deleteHandler(Request request) async {
  if (request.params case {'id': String id}) {
    exercise.delete(.parse(id));
    return .ok(0);
  }
  return .badRequest();
}

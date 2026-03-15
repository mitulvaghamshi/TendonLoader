import 'dart:convert';

import 'package:api_server/service/exercise_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

class ExerciseController {
  const ExerciseController(this.service);

  factory ExerciseController.init({required Database db}) => .new(.new(db));

  final ExerciseService service;

  Future<Response> queryHandler(Request request) async {
    try {
      return .ok(jsonEncode(service.selectAll()));
    } on Exception {
      return .internalServerError(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': 'Internal server error!'},
        }),
      );
    }
  }

  Future<Response> selectHandler(Request request) async {
    try {
      if (request.params case {'id': final String id}) {
        return .ok(jsonEncode(service.selectBy(int.parse(id))));
      }
      return .badRequest(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': 'Missing ID'},
        }),
      );
    } on FormatException catch (e) {
      return .badRequest(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': e.message},
        }),
      );
    } on Exception {
      return .internalServerError(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': 'Internal server error!'},
        }),
      );
    }
  }

  Future<Response> searchHandler(Request request) async {
    try {
      if (request.params case {'term': final String term}) {
        return .ok(jsonEncode(service.search(term)));
      }
      return .badRequest(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': 'Missing search term'},
        }),
      );
    } on Exception {
      return .internalServerError(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': 'Internal server error!'},
        }),
      );
    }
  }

  Future<Response> insertHandler(Request request) async {
    try {
      final body = await request.readAsString();
      if (jsonDecode(body) case {
        'user_id': final int userId,
        'prescription_id': final int? prescriptionId,
        'pain_score': final num painScore,
        'datetime': final String datetime,
        'tolerable': final String tolerable,
        'completed': final int completed,
        'progressor_id': final String progressorId,
        'mvc_value': final num? mvcValue,
        'data': final String data,
      }) {
        service.insert(
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
      return .badRequest(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': 'Invalid data format'},
        }),
      );
    } on FormatException catch (e) {
      return .badRequest(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': e.message},
        }),
      );
    } on Exception {
      return .internalServerError(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': 'Internal server error!'},
        }),
      );
    }
  }

  Future<Response> updateHandler(Request request) async {
    try {
      if (request.params case {'id': final String id}) {
        final body = await request.readAsString();
        if (jsonDecode(body) case {
          'user_id': final int userId,
          'prescription_id': final int? prescriptionId,
          'pain_score': final num painScore,
          'datetime': final String datetime,
          'tolerable': final String tolerable,
          'completed': final int completed,
          'progressor_id': final String progressorId,
          'mvc_value': final num? mvcValue,
          'data': final String data,
        }) {
          service.update(
            id: int.parse(id),
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
        return .badRequest(
          body: jsonEncode({
            'status': 'FAILED',
            'data': {'error': 'Invalid data format'},
          }),
        );
      }
      return .badRequest(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': 'Missing ID'},
        }),
      );
    } on FormatException catch (e) {
      return .badRequest(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': e.message},
        }),
      );
    } on Exception {
      return .internalServerError(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': 'Internal server error!'},
        }),
      );
    }
  }

  Future<Response> deleteHandler(Request request) async {
    try {
      if (request.params case {'id': final String id}) {
        service.delete(int.parse(id));
        return .ok(0);
      }
      return .badRequest(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': 'Missing ID'},
        }),
      );
    } on FormatException catch (e) {
      return .badRequest(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': e.message},
        }),
      );
    } on Exception {
      return .internalServerError(
        body: jsonEncode({
          'status': 'FAILED',
          'data': {'error': 'Internal server error!'},
        }),
      );
    }
  }
}

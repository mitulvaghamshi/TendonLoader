import 'dart:convert';

import 'package:api_server/service/prescription_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

class const PrescriptionController(final PrescriptionService service) {
  factory init({required Database db}) => .new(.new(db));

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
        'reps': final int reps,
        'sets': final int sets,
        'set_rest': final int setRest,
        'hold_time': final int holdTime,
        'rest_time': final int restTime,
        'mvc_duration': final int mvcDuration,
        'target_load': final num targetLoad,
      }) {
        service.insert(
          sets: sets,
          reps: reps,
          setRest: setRest,
          holdTime: holdTime,
          restTime: restTime,
          mvcDuration: mvcDuration,
          targetLoad: targetLoad.toDouble(),
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
          'reps': final int reps,
          'sets': final int sets,
          'set_rest': final int setRest,
          'hold_time': final int holdTime,
          'rest_time': final int restTime,
          'mvc_duration': final int mvcDuration,
          'target_load': final num targetLoad,
        }) {
          service.update(
            id: int.parse(id),
            sets: sets,
            reps: reps,
            setRest: setRest,
            holdTime: holdTime,
            restTime: restTime,
            mvcDuration: mvcDuration,
            targetLoad: targetLoad.toDouble(),
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

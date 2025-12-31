import 'dart:convert';

import 'package:server/services/prescription_service.dart' as prescription;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Response queryHandler(Request request) =>
    .ok(jsonEncode(prescription.selectAll));

Response selectHandler(Request request) {
  if (request.params case {'id': String id}) {
    return .ok(jsonEncode(prescription.selectBy(.parse(id))));
  }
  return .badRequest();
}

Response searchHandler(Request request) {
  if (request.params case {'term': String term}) {
    return .ok(jsonEncode(prescription.search(term)));
  }
  return .badRequest();
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
    return .ok(0);
  }
  return .badRequest();
}

Future<Response> updateHandler(Request request) async {
  if (request.params case {'id': String id}) {
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
        id: .parse(id),
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
  }
  return .badRequest();
}

Future<Response> deleteHandler(Request request) async {
  if (request.params case {'id': String id}) {
    prescription.delete(.parse(id));
    return .ok(0);
  }
  return .badRequest();
}

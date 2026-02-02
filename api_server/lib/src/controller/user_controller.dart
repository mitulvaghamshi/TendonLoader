import 'dart:convert';

import 'package:api_server/api_server.dart';
import 'package:api_server/src/service/user_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UserController {
  const UserController(this.service);

  final UserService service;

  Future<Response> authHandler(Request request) async {
    try {
      final body = await request.readAsString();
      final user = User.fromJson(jsonDecode(body));
      final result = service.authenticate(user: user);
      if (result.data case User user) {
        return .ok(jsonEncode(user.map));
      }
      return .unauthorized(
        jsonEncode({
          'status': 'FAILED',
          'data': {'error': result.error ?? 'Something went wrong!'},
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
      if (request.params case {'id': String id}) {
        final result = service.selectBy(userId: .parse(id));
        return .ok(jsonEncode(result));
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
      if (request.params case {'term': String term}) {
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
      final user = User.fromJson(jsonDecode(body));
      service.insert(user: user);
      return .ok(jsonEncode(0));
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
      final body = await request.readAsString();
      final user = User.fromJson(jsonDecode(body));
      service.update(user: user);
      return .ok(jsonEncode(0));
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
      if (request.params case {'id': String id}) {
        service.delete(userId: .parse(id));
        return .ok(jsonEncode(0));
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

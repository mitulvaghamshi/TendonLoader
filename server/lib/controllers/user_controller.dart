import 'dart:convert';

import 'package:server/services/user_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UserController {
  const UserController(this.service);

  final UserService service;

  Future<Response> authHandler(Request request) async {
    final body = await request.readAsString();
    if (jsonDecode(body) case {
      'username': String username,
      'password': String password,
    }) {
      final result = service.auth(username: username, password: password);
      if (result.isEmpty || result.first.isEmpty) {
        return .unauthorized('Access denied!\n');
      }
      return .ok(
        jsonEncode({
          'id': result.first.columnAt(0),
          'token': Object.hashAll(result),
        }),
      );
    }
    return .unauthorized(1);
  }

  Response queryHandler(Request request) =>
      .ok(jsonEncode(service.selectAll()));

  Response selectHandler(Request request) {
    if (request.params case {'id': String id}) {
      return .ok(jsonEncode(service.selectBy(int.parse(id))));
    }
    return .badRequest();
  }

  Response searchHandler(Request request) {
    if (request.params case {'term': String term}) {
      return .ok(jsonEncode(service.search(term)));
    }
    return .badRequest();
  }

  Future<Response> insertHandler(Request request) async {
    final body = await request.readAsString();
    if (jsonDecode(body) case {
      'username': String username,
      'password': String password,
    }) {
      service.insert(username: username, password: password);
      return .ok(0);
    }
    return .badRequest();
  }

  Future<Response> updateHandler(Request request) async {
    if (request.params case {'id': String id}) {
      final body = await request.readAsString();
      if (jsonDecode(body) case {
        'username': String username,
        'password': String password,
      }) {
        service.update(
          id: int.parse(id),
          username: username,
          password: password,
        );
        return .ok(0);
      }
    }
    return .badRequest();
  }

  Future<Response> deleteHandler(Request request) async {
    if (request.params case {'id': String id}) {
      service.delete(int.parse(id));
      return .ok(0);
    }
    return .badRequest();
  }
}

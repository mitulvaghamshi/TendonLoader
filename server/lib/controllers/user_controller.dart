import 'dart:convert';

import 'package:server/services/user_service.dart';
import 'package:server/statements/user_statements.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

extension UserController on UserStatements {
  Future<Response> authHandler(Request request) async {
    final body = await request.readAsString();
    if (jsonDecode(body) case {'credential': String cred}) {
      final creds = utf8.decode(base64.decode(cred)).split(':');
      final result = auth(creds[0], creds[1]);
      if (result.isEmpty || result.first.isEmpty) {
        return Response.unauthorized('Access denied!\n');
      }
      return Response.ok(
        jsonEncode({
          'id': result.first.columnAt(0),
          'token': Object.hashAll(result.first.values),
        }),
      );
    }
    return Response.unauthorized('Invalid request $body\n');
  }

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
      'username': String username,
      'password': String password,
    }) {
      insert(username: username, password: password);
      return Response.ok('Inserted successfully');
    }
    return Response.badRequest(body: 'Invalid request body');
  }

  Future<Response> updateHandler(Request request) async {
    final id = int.tryParse(request.params['id'].toString());
    if (id == null) return Response.badRequest(body: 'Invalid request');
    final body = await request.readAsString();
    if (jsonDecode(body) case {
      'username': String username,
      'password': String password,
    }) {
      update(id: id, username: username, password: password);
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

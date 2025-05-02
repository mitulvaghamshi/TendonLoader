import 'dart:convert';

import 'package:server/services/user_service.dart' as user;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> authHandler(Request request) async {
  final body = await request.readAsString();
  if (jsonDecode(body) case {'credential': String cred}) {
    final creds = utf8.decode(base64.decode(cred)).split(':');
    final result = user.auth(creds[0], creds[1]);
    if (result.isEmpty || result.first.isEmpty) {
      return Response.unauthorized('Access denied!\n');
    }
    return Response.ok(
      jsonEncode({
        'id': result.first.columnAt(0),
        'token': Object.hashAll(result),
      }),
    );
  }
  return Response.unauthorized(1);
}

Response queryHandler(Request request) =>
    Response.ok(jsonEncode(user.selectAll));

Response selectHandler(Request request) {
  final id = int.tryParse(request.params['id'].toString());
  if (id == null) {
    return Response.badRequest();
  }
  return Response.ok(jsonEncode(user.selectBy(id)));
}

Response searchHandler(Request request) {
  final term = request.params['term'];
  if (term == null) {
    return Response.badRequest();
  }
  return Response.ok(jsonEncode(user.search(term)));
}

Future<Response> insertHandler(Request request) async {
  final body = await request.readAsString();
  if (jsonDecode(body) case {
    'username': String username,
    'password': String password,
  }) {
    user.insert(username: username, password: password);
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
    'username': String username,
    'password': String password,
  }) {
    user.update(id: id, username: username, password: password);
    return Response.ok(0);
  }
  return Response.badRequest();
}

Future<Response> deleteHandler(Request request) async {
  final id = int.tryParse(request.params['id'].toString());
  if (id == null) {
    return Response.badRequest();
  }
  user.delete(id);
  return Response.ok(0);
}

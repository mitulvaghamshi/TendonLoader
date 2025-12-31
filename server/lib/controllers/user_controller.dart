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

Response queryHandler(Request request) => .ok(jsonEncode(user.selectAll));

Response selectHandler(Request request) {
  if (request.params case {'id': String id}) {
    return .ok(jsonEncode(user.selectBy(.parse(id))));
  }
  return .badRequest();
}

Response searchHandler(Request request) {
  if (request.params case {'term': String term}) {
    return .ok(jsonEncode(user.search(term)));
  }
  return .badRequest();
}

Future<Response> insertHandler(Request request) async {
  final body = await request.readAsString();
  if (jsonDecode(body) case {
    'username': String username,
    'password': String password,
  }) {
    user.insert(username: username, password: password);
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
      user.update(id: .parse(id), username: username, password: password);
      return .ok(0);
    }
  }
  return .badRequest();
}

Future<Response> deleteHandler(Request request) async {
  if (request.params case {'id': String id}) {
    user.delete(.parse(id));
    return .ok(0);
  }
  return .badRequest();
}

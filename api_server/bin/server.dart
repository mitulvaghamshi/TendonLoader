import 'dart:io';

import 'package:api_server/src/router/app_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

Future<void> main() async {
  final router = AppRouter.configure();

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.rootRouter.call);

  final host = InternetAddress(InternetAddress.anyIPv4.host);
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final server = await io.serve(handler.call, host, port);

  print('Server listening on port ${server.port}...');
  print('API docs at: http://${server.address.host}:${server.port}/docs');
}

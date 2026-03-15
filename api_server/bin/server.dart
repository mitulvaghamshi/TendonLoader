import 'dart:io';

import 'package:api_server/router/app_router.dart';
import 'package:api_server/router/middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart' as ss;

Future<void> main() async {
  final router = AppRouter.configure();

  final apiHandler = router.apiHandler.call;

  final fileHandler = ss.createStaticHandler(
    'web',
    defaultDocument: 'index.html',
  );

  final corsMiddleware = cors({
    'origins': ['http://localhost:3001'],
    'credentials': true,
  });

  final logPipeline = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware);

  final handler = logPipeline.addHandler((request) async {
    final segments = request.url.pathSegments;
    if (segments.isEmpty) {
      return fileHandler(request);
    }
    if (segments.first == 'api' || segments.first == 'docs') {
      return apiHandler(request);
    }
    if (await File('web/${request.url.toFilePath()}').exists()) {
      return fileHandler(request);
    }
    return .notFound(
      '<h1>404 Not Found!</h1>\n',
      headers: {HttpHeaders.contentTypeHeader: ContentType.html.value},
    );
  });

  final host = Platform.environment['HOST'] ?? '127.0.0.1';
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final server = await io.serve(handler.call, host, port);

  print('Server listening on port ${server.port}...');
  print('API docs at: http://${server.address.host}:${server.port}/docs');
}

import 'dart:io';

import 'package:server/utils/app_router.dart';
import 'package:server/utils/config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

Future<void> main() async {
  final dbPath = ArgumentError.checkNotNull(
    Platform.environment['DB_PATH'],
    'DB_PATH environment variable',
  );

  final config = Config.create(dbPath);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(config.router.rootRouter.call);

  final host = InternetAddress(InternetAddress.anyIPv4.host);
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, host, port);

  print('Server listening on port ${server.port}...');
}

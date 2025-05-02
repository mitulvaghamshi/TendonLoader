import 'dart:io';

import 'package:server/utils/config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

Future<void> main() async {
  final config = Config.create();
  await config.init();

  /// Configure a pipeline that logs requests.
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(config.handler);

  final ip = InternetAddress('localhost');
  const port = int.fromEnvironment('PORT', defaultValue: 8080);
  final server = await serve(handler, ip, port);

  print('Server listening on port ${server.port}...');
}

import 'dart:io';

import 'package:server/utils/config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

void main() async {
  final config = Config.fromEnv();
  await config.init();

  /// Configure a pipeline that logs requests.
  final handler = const Pipeline() //
      .addMiddleware(logRequests())
      .addHandler(config.rootHandler);

  final ip = InternetAddress.loopbackIPv4;
  final port = int.parse(
    const String.fromEnvironment('PORT', defaultValue: '8080'),
  );
  final server = await serve(handler, ip, port);

  print('Server listening on port ${server.port}...');
}

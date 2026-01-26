import 'package:shelf/shelf_io.dart' as io;
import 'package:swagger_ui/swagger_ui.dart';

void main(List<String> args) async {
  final handler = await SwaggerUI.fromFile(path: 'bin/pet-schema.json');
  final server = await io.serve(handler.call, 'localhost', 3002);
  print('Serving at http://${server.address.host}:${server.port}');
}

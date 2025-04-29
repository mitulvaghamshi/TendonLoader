import 'package:server/controllers/settings_controller.dart';
import 'package:server/statements/settings_statements.dart';
import 'package:shelf_router/shelf_router.dart';

extension SettingsRouter on SettingsStatements {
  Router get settingsRouter =>
      Router()
        // curl -X GET http://localhost:8080/settings
        ..get('/', queryHandler)
        // curl -X GET http://localhost:8080/settings/1
        ..get('/<id>', selectHandler)
        // curl -X GET http://localhost:8080/settings/search/term
        ..get('/search/<term>', searchHandler)
        // curl -X POST http://localhost:8080/settings -H 'Content-Type: application/json' -d '{}'
        ..post('/', insertHandler)
        // curl -X PATCH http://localhost:8080/settings/1 -H 'Content-Type: application/json' -d '{}'
        ..patch('/<id>', updateHandler)
        // curl -X DELETE http://localhost:8080/settings/1
        ..delete('/<id>', deleteHandler);
}

import 'package:server/controllers/user_controller.dart';
import 'package:server/statements/user_statements.dart';
import 'package:shelf_router/shelf_router.dart';

extension UserRouter on UserStatements {
  Router get userRouter =>
      Router()
        // curl -X GET http://localhost:8080/users
        ..get('/', queryHandler)
        // curl -X GET http://localhost:8080/users/1
        ..get('/<id>', selectHandler)
        // curl -X POST http://localhost:8080/users/auth -H 'Content-Type: application/json' -d '{}'
        ..post('/auth', authHandler)
        // curl -X GET http://localhost:8080/users/search/<term>
        ..get('/search/<term>', searchHandler)
        // curl -X POST http://localhost:8080/users -H 'Content-Type: application/json' -d '{}'
        ..post('/', insertHandler)
        // curl -X PATCH http://localhost:8080/users/1 -H 'Content-Type: application/json' -d '{}'
        ..patch('/<id>', updateHandler)
        // curl -X DELETE http://localhost:8080/users/1
        ..delete('/<id>', deleteHandler);
}

import 'package:server/controllers/exercise_controller.dart';
import 'package:server/statements/exercise_statements.dart';
import 'package:shelf_router/shelf_router.dart';

extension ExerciseRouter on ExerciseStatements {
  Router get exerciseRouter =>
      Router()
        // curl -X GET http://localhost:8080/exercises
        ..get('/', queryHandler)
        // curl -X GET http://localhost:8080/exercises/1
        ..get('/<id>', selectHandler)
        // curl -X GET http://localhost:8080/exercises/search/term
        ..get('/search/<term>', searchHandler)
        // curl -X POST http://localhost:8080/exercises -H 'Content-Type: application/json' -d '{}'
        ..post('/', insertHandler)
        // curl -X PATCH http://localhost:8080/exercises/1 -H 'Content-Type: application/json' -d '{}'
        ..patch('/<id>', updateHandler)
        // curl -X DELETE http://localhost:8080/exercises/1
        ..delete('/<id>', deleteHandler);
}

import 'package:server/controllers/exercise_controller.dart' as exercise;
import 'package:server/controllers/prescription_controller.dart'
    as prescription;
import 'package:server/controllers/settings_controller.dart' as settings;
import 'package:server/controllers/user_controller.dart' as user;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Router get appRouter =>
    Router()
      // curl http://localhost:8080
      ..get('/', (_) => Response.ok('<h2>TendonLoader API v1.0</h2>\n'))
      // curl http://localhost:8080/users
      ..mount('/users', _userRouter.call)
      // curl http://localhost:8080/settings
      ..mount('/settings', _settingsRouter.call)
      // curl http://localhost:8080/exercises
      ..mount('/exercises', _exerciseRouter.call)
      // curl http://localhost:8080/prescription
      ..mount('/prescriptions', _prescriptionRouter.call);

Router get _userRouter =>
    Router()
      // curl -X GET http://localhost:8080/users
      ..get('/', user.queryHandler)
      // curl -X GET http://localhost:8080/users/1
      ..get('/<id>', user.selectHandler)
      // curl -X POST http://localhost:8080/users/auth -H 'Content-Type: application/json' -d '{}'
      ..post('/auth', user.authHandler)
      // curl -X GET http://localhost:8080/users/search/<term>
      ..get('/search/<term>', user.searchHandler)
      // curl -X POST http://localhost:8080/users -H 'Content-Type: application/json' -d '{}'
      ..post('/', user.insertHandler)
      // curl -X PATCH http://localhost:8080/users/1 -H 'Content-Type: application/json' -d '{}'
      ..patch('/<id>', user.updateHandler)
      // curl -X DELETE http://localhost:8080/users/1
      ..delete('/<id>', user.deleteHandler);

Router get _settingsRouter =>
    Router()
      // curl -X GET http://localhost:8080/settings
      ..get('/', settings.queryHandler)
      // curl -X GET http://localhost:8080/settings/1
      ..get('/<id>', settings.selectHandler)
      // curl -X GET http://localhost:8080/settings/search/term
      ..get('/search/<term>', settings.searchHandler)
      // curl -X POST http://localhost:8080/settings -H 'Content-Type: application/json' -d '{}'
      ..post('/', settings.insertHandler)
      // curl -X PATCH http://localhost:8080/settings/1 -H 'Content-Type: application/json' -d '{}'
      ..patch('/<id>', settings.updateHandler)
      // curl -X DELETE http://localhost:8080/settings/1
      ..delete('/<id>', settings.deleteHandler);

Router get _prescriptionRouter =>
    Router()
      // curl -X GET http://localhost:8080/prescriptions
      ..get('/', prescription.queryHandler)
      // curl -X GET http://localhost:8080/prescriptions/1
      ..get('/<id>', prescription.selectHandler)
      // curl -X GET http://localhost:8080/prescriptions/search/term
      ..get('/search/<term>', prescription.searchHandler)
      // curl -X POST http://localhost:8080/prescriptions -H 'Content-Type: application/json' -d '{}'
      ..post('/', prescription.insertHandler)
      // curl -X PATCH http://localhost:8080/prescriptions/1 -H 'Content-Type: application/json' -d '{}'
      ..patch('/<id>', prescription.updateHandler)
      // curl -X DELETE http://localhost:8080/prescriptions/1
      ..delete('/<id>', prescription.deleteHandler);

Router get _exerciseRouter =>
    Router()
      // curl -X GET http://localhost:8080/exercises
      ..get('/', exercise.queryHandler)
      // curl -X GET http://localhost:8080/exercises/1
      ..get('/<id>', exercise.selectHandler)
      // curl -X GET http://localhost:8080/exercises/search/term
      ..get('/search/<term>', exercise.searchHandler)
      // curl -X POST http://localhost:8080/exercises -H 'Content-Type: application/json' -d '{}'
      ..post('/', exercise.insertHandler)
      // curl -X PATCH http://localhost:8080/exercises/1 -H 'Content-Type: application/json' -d '{}'
      ..patch('/<id>', exercise.updateHandler)
      // curl -X DELETE http://localhost:8080/exercises/1
      ..delete('/<id>', exercise.deleteHandler);

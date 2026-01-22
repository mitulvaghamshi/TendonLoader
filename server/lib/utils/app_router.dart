import 'package:server/controllers/exercise_controller.dart';
import 'package:server/controllers/prescription_controller.dart';
import 'package:server/controllers/settings_controller.dart';
import 'package:server/controllers/user_controller.dart';
import 'package:server/utils/middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AppRouter {
  const AppRouter({
    required this.userController,
    required this.settingsController,
    required this.exerciseController,
    required this.prescriptionController,
  });

  final UserController userController;
  final SettingsController settingsController;
  final ExerciseController exerciseController;
  final PrescriptionController prescriptionController;
}

extension RootRouter on AppRouter {
  Router get rootRouter {
    final auth = AuthMiddleware(userController.service);
    final pipe = const Pipeline().addMiddleware(auth.checkAuthentication);
    return Router()
      // Public Routes
      ..get('/api', (_) => Response.ok('<h2>TendonLoader API v1.0</h2>\n'))
      ..post('/api/users/auth', userController.authHandler)
      ..post('/api/users', userController.insertHandler)
      // Protected Routes
      // curl http://localhost:3001/users
      ..mount('/api/users', pipe.addHandler(_protectedUserRouter.call))
      // curl http://localhost:3001/settings
      ..mount('/api/settings', pipe.addHandler(_settingsRouter.call))
      // curl http://localhost:3001/exercises
      ..mount('/api/exercises', pipe.addHandler(_exerciseRouter.call))
      // curl http://localhost:3001/prescription
      ..mount('/api/prescription', pipe.addHandler(_prescriptionRouter.call));
  }
}

extension on AppRouter {
  Router get _protectedUserRouter => Router()
    ..get('/', userController.queryHandler)
    // curl -X GET http://localhost:3001/users/1
    ..get('/<id>', userController.selectHandler)
    // curl -X POST http://localhost:3001/users/auth -H 'Content-Type: application/json' -d '{}'
    ..post('/auth', userController.authHandler)
    // curl -X GET http://localhost:3001/users/search/<term>
    ..get('/search/<term>', userController.searchHandler)
    // curl -X POST http://localhost:3001/users -H 'Content-Type: application/json' -d '{}'
    ..post('/', userController.insertHandler)
    // curl -X PATCH http://localhost:3001/users/1 -H 'Content-Type: application/json' -d '{}'
    ..patch('/<id>', userController.updateHandler)
    // curl -X DELETE http://localhost:3001/users/1
    ..delete('/<id>', userController.deleteHandler);

  Router get _settingsRouter => Router()
    // curl -X GET http://localhost:3001/settings
    ..get('/', settingsController.queryHandler)
    // curl -X GET http://localhost:3001/settings/1
    ..get('/<id>', settingsController.selectHandler)
    // curl -X GET http://localhost:3001/settings/search/term
    ..get('/search/<term>', settingsController.searchHandler)
    // curl -X POST http://localhost:3001/settings -H 'Content-Type: application/json' -d '{}'
    ..post('/', settingsController.insertHandler)
    // curl -X PATCH http://localhost:3001/settings/1 -H 'Content-Type: application/json' -d '{}'
    ..patch('/<id>', settingsController.updateHandler)
    // curl -X DELETE http://localhost:3001/settings/1
    ..delete('/<id>', settingsController.deleteHandler);

  Router get _prescriptionRouter => Router()
    // curl -X GET http://localhost:3001/prescription
    ..get('/', prescriptionController.queryHandler)
    // curl -X GET http://localhost:3001/prescription/1
    ..get('/<id>', prescriptionController.selectHandler)
    // curl -X GET http://localhost:3001/prescription/search/term
    ..get('/search/<term>', prescriptionController.searchHandler)
    // curl -X POST http://localhost:3001/prescription -H 'Content-Type: application/json' -d '{}'
    ..post('/', prescriptionController.insertHandler)
    // curl -X PATCH http://localhost:3001/prescription/1 -H 'Content-Type: application/json' -d '{}'
    ..patch('/<id>', prescriptionController.updateHandler)
    // curl -X DELETE http://localhost:3001/prescription/1
    ..delete('/<id>', prescriptionController.deleteHandler);

  Router get _exerciseRouter => Router()
    // curl -X GET http://localhost:3001/exercises
    ..get('/', exerciseController.queryHandler)
    // curl -X GET http://localhost:3001/exercises/1
    ..get('/<id>', exerciseController.selectHandler)
    // curl -X GET http://localhost:3001/exercises/search/term
    ..get('/search/<term>', exerciseController.searchHandler)
    // curl -X POST http://localhost:3001/exercises -H 'Content-Type: application/json' -d '{}'
    ..post('/', exerciseController.insertHandler)
    // curl -X PATCH http://localhost:3001/exercises/1 -H 'Content-Type: application/json' -d '{}'
    ..patch('/<id>', exerciseController.updateHandler)
    // curl -X DELETE http://localhost:3001/exercises/1
    ..delete('/<id>', exerciseController.deleteHandler);
}

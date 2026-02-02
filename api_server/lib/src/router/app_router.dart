import 'dart:convert';
import 'dart:io';

import 'package:api_server/src/controller/exercise_controller.dart';
import 'package:api_server/src/controller/prescription_controller.dart';
import 'package:api_server/src/controller/settings_controller.dart';
import 'package:api_server/src/controller/user_controller.dart';
import 'package:api_server/src/router/app_route.dart';
import 'package:api_server/src/router/middleware.dart';
import 'package:api_server/src/router/swagger_ui.dart';
import 'package:api_server/src/service/exercise_service.dart';
import 'package:api_server/src/service/prescription_service.dart';
import 'package:api_server/src/service/settings_service.dart';
import 'package:api_server/src/service/user_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

class AppRouter {
  const AppRouter({
    required this.userController,
    required this.settingsController,
    required this.exerciseController,
    required this.prescriptionController,
  });

  factory AppRouter.configure() {
    final dbPath = ArgumentError.checkNotNull(
      Platform.environment['DB_PATH'],
      'DB_PATH environment variable',
    );

    final db = sqlite3.open(dbPath);

    final router = AppRouter(
      userController: UserController(UserService(db)..init()),
      settingsController: SettingsController(SettingsService(db)),
      exerciseController: ExerciseController(ExerciseService(db)),
      prescriptionController: PrescriptionController(PrescriptionService(db)),
    );

    final schema = router.openApiSchema;
    final swaggerUi = SwaggerUI(schema, title: 'TendonLoader API');

    router.rootRouter.mount('/docs', swaggerUi.call);
    router.rootRouter.get(
      '/docs/openapi.json',
      (_) => Response.ok(
        schema,
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
      ),
    );

    return router;
  }

  final UserController userController;
  final SettingsController settingsController;
  final ExerciseController exerciseController;
  final PrescriptionController prescriptionController;
}

extension AppRouterExt on AppRouter {
  String get openApiSchema => jsonEncode(_schema);

  Router get rootRouter {
    final router = Router();
    final auth = AuthMiddleware(userController.service);
    final authMiddleware = auth.checkAuthentication;

    for (final route in _routes) {
      var handler = route.handler;
      if (!route.public) {
        handler = const Pipeline()
            .addMiddleware(authMiddleware)
            .addHandler(handler);
      }
      router.add(route.method, route.path, handler);
    }
    return router;
  }
}

extension on AppRouter {
  Map<String, dynamic> get _schema {
    final paths = <String, Map<String, dynamic>>{};

    for (final route in _routes) {
      // Convert /path/<id> to /path/{id}
      final openApiPath = route.path.replaceAllMapped(
        RegExp('<([^>]+)>'),
        (match) => '{${match.group(1)}}',
      );

      if (!paths.containsKey(openApiPath)) {
        paths[openApiPath] = {};
      }

      final pathItem = paths[openApiPath]!;
      final method = route.method.toLowerCase();

      final parameters = <Map<String, dynamic>>[];
      final paramMatches = RegExp('<([^>]+)>').allMatches(route.path);
      for (final match in paramMatches) {
        parameters.add({
          'name': match.group(1),
          'in': 'path',
          'required': true,
          'schema': {'type': 'string'}, // Default to string
        });
      }

      pathItem[method] = {
        'tags': [route.tag],
        'summary': route.summary ?? '',
        'description': route.description ?? '',
        'parameters': parameters,
        'responses': {
          '200': {'description': 'OK'},
        },
      };

      // Add bearer auth for non-public routes
      final operation = pathItem[method] as Map<String, dynamic>;

      if (!route.public) {
        operation['security'] = [
          {'BearerAuth': []},
        ];
      }
    }

    return {
      'openapi': '3.0.0',
      'info': {
        'title': 'TendonLoader API',
        'version': '1.0.0',
        'description': 'API documentation for TendonLoader',
      },
      'components': {
        'securitySchemes': {
          'BearerAuth': {
            'type': 'http',
            'scheme': 'bearer',
            'bearerFormat': 'JWT',
          },
        },
      },
      'paths': paths,
    };
  }
}

extension on AppRouter {
  Iterable<AppRoute> get _routes => [
    // Public Routes
    AppRoute.get(
      path: '/api',
      handler: (_) => .ok('<h2>TendonLoader API v1.0</h2>\n'),
      tag: 'System',
      public: true,
      summary: 'API Root',
      description: 'Default API Route when no path is specified',
    ),
    AppRoute.post(
      path: '/api/users/auth',
      handler: userController.authHandler,
      public: true,
      tag: 'User',
      summary: 'Authenticate User',
    ),
    AppRoute.post(
      path: '/api/users',
      handler: userController.insertHandler,
      public: true,
      tag: 'User',
      summary: 'Register User',
    ),

    // User Routes (Protected)
    AppRoute.get(
      path: '/api/users',
      handler: userController.queryHandler,
      tag: 'User',
    ),
    AppRoute.get(
      path: '/api/users/<id>',
      handler: userController.selectHandler,
      tag: 'User',
    ),
    AppRoute.get(
      path: '/api/users/search/<term>',
      handler: userController.searchHandler,
      tag: 'User',
    ),
    AppRoute.patch(
      path: '/api/users/<id>',
      handler: userController.updateHandler,
      tag: 'User',
    ),
    AppRoute.delete(
      path: '/api/users/<id>',
      handler: userController.deleteHandler,
      tag: 'User',
    ),

    // Settings Routes (Protected)
    AppRoute.get(
      path: '/api/settings',
      handler: settingsController.queryHandler,
      tag: 'Settings',
    ),
    AppRoute.get(
      path: '/api/settings/<id>',
      handler: settingsController.selectHandler,
      tag: 'Settings',
    ),
    AppRoute.get(
      path: '/api/settings/search/<term>',
      handler: settingsController.searchHandler,
      tag: 'Settings',
    ),
    AppRoute.post(
      path: '/api/settings',
      handler: settingsController.insertHandler,
      tag: 'Settings',
    ),
    AppRoute.patch(
      path: '/api/settings/<id>',
      handler: settingsController.updateHandler,
      tag: 'Settings',
    ),
    AppRoute.delete(
      path: '/api/settings/<id>',
      handler: settingsController.deleteHandler,
      tag: 'Settings',
    ),

    // Exercise Routes (Protected)
    AppRoute.get(
      path: '/api/exercises',
      handler: exerciseController.queryHandler,
      tag: 'Exercise',
    ),
    AppRoute.get(
      path: '/api/exercises/<id>',
      handler: exerciseController.selectHandler,
      tag: 'Exercise',
    ),
    AppRoute.get(
      path: '/api/exercises/search/<term>',
      handler: exerciseController.searchHandler,
      tag: 'Exercise',
    ),
    AppRoute.post(
      path: '/api/exercises',
      handler: exerciseController.insertHandler,
      tag: 'Exercise',
    ),
    AppRoute.patch(
      path: '/api/exercises/<id>',
      handler: exerciseController.updateHandler,
      tag: 'Exercise',
    ),
    AppRoute.delete(
      path: '/api/exercises/<id>',
      handler: exerciseController.deleteHandler,
      tag: 'Exercise',
    ),

    // Prescription Routes (Protected)
    AppRoute.get(
      path: '/api/prescription',
      handler: prescriptionController.queryHandler,
      tag: 'Prescription',
    ),
    AppRoute.get(
      path: '/api/prescription/<id>',
      handler: prescriptionController.selectHandler,
      tag: 'Prescription',
    ),
    AppRoute.get(
      path: '/api/prescription/search/<term>',
      handler: prescriptionController.searchHandler,
      tag: 'Prescription',
    ),
    AppRoute.post(
      path: '/api/prescription',
      handler: prescriptionController.insertHandler,
      tag: 'Prescription',
    ),
    AppRoute.patch(
      path: '/api/prescription/<id>',
      handler: prescriptionController.updateHandler,
      tag: 'Prescription',
    ),
    AppRoute.delete(
      path: '/api/prescription/<id>',
      handler: prescriptionController.deleteHandler,
      tag: 'Prescription',
    ),
  ];
}

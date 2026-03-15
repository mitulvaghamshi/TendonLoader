import 'dart:convert';
import 'dart:io';

import 'package:api_server/api_server.dart';
import 'package:api_server/controller/exercise_controller.dart';
import 'package:api_server/controller/prescription_controller.dart';
import 'package:api_server/controller/settings_controller.dart';
import 'package:api_server/controller/user_controller.dart';
import 'package:api_server/router/app_route.dart';
import 'package:api_server/router/middleware.dart';
import 'package:api_server/router/swagger_ui.dart';
import 'package:api_server/sql/chart_data_table.dart';
import 'package:api_server/sql/exercise_table.dart';
import 'package:api_server/sql/prescription_table.dart';
import 'package:api_server/sql/settings_table.dart';
import 'package:api_server/sql/user_table.dart';
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
      'DB_PATH',
    );
    final database = sqlite3.open(dbPath);

    return AppRouter(
      userController: .init(db: database),
      settingsController: .init(db: database),
      exerciseController: .init(db: database),
      prescriptionController: .init(db: database),
    );
  }

  final UserController userController;
  final SettingsController settingsController;
  final ExerciseController exerciseController;
  final PrescriptionController prescriptionController;
}

extension AppRouterExt on AppRouter {
  Router get apiHandler {
    final router = Router();
    final auth = checkAuth(userController.service);

    for (var route in _apiRoutes) {
      var handler = route.handler;
      if (!route.public) {
        handler = const Pipeline().addMiddleware(auth).addHandler(handler);
      }
      router.add(route.method, route.path, handler);
    }

    final schema = jsonEncode(_buildOpenApiSchema);
    final swaggerUi = SwaggerUI(schema, title: 'TendonLoader API');
    router.mount('/docs', swaggerUi.call);
    router.get(
      '/docs/openapi.json',
      (_) => Response.ok(
        schema,
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
      ),
    );

    return router;
  }
}

extension on AppRouter {
  Map<String, dynamic> get _buildOpenApiSchema {
    final paths = <String, Map<String, dynamic>>{};

    for (var route in _apiRoutes) {
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
      for (var match in paramMatches) {
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
        if (method == 'get')
          'responses': switch (route.tag) {
            UserTable.kTable => UserTable.getResponses,
            SettingsTable.kTable => SettingsTable.getResponses,
            ExerciseTable.kTable => ExerciseTable.getResponses,
            PrescriptionTable.kTable => PrescriptionTable.getResponses,
            _ => {
              '2XX': {'description': 'OK'},
              '5XX': {r'$ref': '#/components/responses/ServerError'},
            },
          },
      };

      // Add bearer auth for non-public routes
      final operation = pathItem[method] as Map<String, dynamic>;

      if (!route.public) {
        operation['security'] = [
          {'BearerAuth': <String>[]},
        ];
      }
    }

    return {
      'openapi': '3.0.0',
      'info': {
        'title': 'TendonLoader API',
        'version': '1.0.0',
        'description': 'API docs for Tendon Loader',
      },
      'servers': [
        {
          'url': 'http://localhost:3001', //
          'description': 'Development API',
        },
        {
          'url': 'https://api.tendonloader.com/v1',
          'description': 'Production API',
        },
      ],
      'tags': [
        {'name': '$User', 'description': 'Access to $User'},
        {'name': '$Settings', 'description': 'Access to $Settings'},
        {'name': '$Exercise', 'description': 'Access to $Exercise'},
        {'name': '$Prescription', 'description': 'Access to $Prescription'},
        {'name': '$ChartData', 'description': 'Access to $ChartData'},
      ],
      'components': {
        'securitySchemes': {
          'BearerAuth': {
            'type': 'http',
            'scheme': 'bearer',
            'bearerFormat': 'JWT',
            'description': 'Auth header (Authorization) Access Token',
          },
          'BearerAuthRefreshToken': {
            'type': 'http',
            'scheme': 'bearer',
            'bearerFormat': 'JWT',
            'description': '(Authorization) Refresh Token',
          },
          'BasicAuth': {'type': 'http', 'scheme': 'basic'},
        },
        'responses': {
          'BadRequest': {
            'description': 'Bad Request!',
            'content': {
              'application/json': {
                'schema': {r'$ref': '#/components/schemas/Failure'},
              },
            },
          },
          'Unauthorized': {
            'description': 'Unauthorized Access!',
            'content': {
              'application/json': {
                'schema': {r'$ref': '#/components/schemas/Failure'},
              },
            },
          },
          'Forbidden': {
            'description': 'Access Forbidden!',
            'content': {
              'application/json': {
                'schema': {r'$ref': '#/components/schemas/Failure'},
              },
            },
          },
          'NotFound': {
            'description': 'Not Found!',
            'content': {
              'application/json': {
                'schema': {r'$ref': '#/components/schemas/Failure'},
              },
            },
          },
          'ServerError': {
            'description': 'Internal Server Error!',
            'content': {
              'application/json': {
                'schema': {r'$ref': '#/components/schemas/Failure'},
              },
            },
          },
        },
        'schemas': {
          'Failure': {
            'type': 'object',
            'properties': {
              'status': {'type': 'string', 'example': 'FAILED'},
              'data': {
                'type': 'object',
                'properties': {
                  'error': {
                    'type': 'string',
                    'example': 'Internal server error!',
                  },
                },
              },
            },
            'example': {
              'status': 'FAILED',
              'data': {'error': 'Internal server error!'},
            },
          },
          '$User': UserTable.schema,
          '$Settings': SettingsTable.schema,
          '$Prescription': PrescriptionTable.schema,
          '$Exercise': ExerciseTable.schema,
          '$ChartData': ChartDataTable.schema,
        },
      },
      'paths': paths,
    };
  }
}

extension on AppRouter {
  Iterable<AppRoute> get _apiRoutes => [
    // Public Routes
    .get(
      path: '/api',
      handler: (_) => .ok(
        '<h2>TendonLoader API v1.0</h2>\n',
        headers: {HttpHeaders.contentTypeHeader: ContentType.html.value},
      ),
      responses: {
        '2XX': {'description': 'OK'},
        '5XX': {r'$ref': '#/components/responses/ServerError'},
      },
      description: 'Default API Route when no path is specified',
      summary: 'API Root',
      public: true,
      tag: 'System',
    ),
    .post(
      path: '/api/users/auth',
      handler: userController.authHandler,
      responses: UserTable.postResponses,
      requestBody: UserTable.requestBody,
      summary: 'Authenticate User',
      public: true,
      tag: UserTable.kTable,
    ),
    .post(
      path: '/api/users',
      handler: userController.insertHandler,
      responses: UserTable.postResponses,
      requestBody: UserTable.requestBody,
      summary: 'Register User',
      public: true,
      tag: UserTable.kTable,
    ),

    // User Routes (Protected)
    .get(
      path: '/api/users',
      handler: userController.queryHandler,
      responses: UserTable.getResponses,
      tag: UserTable.kTable,
    ),
    .get(
      path: '/api/users/<id>',
      handler: userController.selectHandler,
      responses: UserTable.getResponses,
      tag: UserTable.kTable,
    ),
    .get(
      path: '/api/users/search/<term>',
      handler: userController.searchHandler,
      responses: UserTable.getResponses,
      tag: UserTable.kTable,
    ),
    .patch(
      path: '/api/users/<id>',
      handler: userController.updateHandler,
      responses: {},
      requestBody: UserTable.requestBody,
      tag: UserTable.kTable,
    ),
    .delete(
      path: '/api/users/<id>',
      handler: userController.deleteHandler,
      responses: {},
      tag: UserTable.kTable,
    ),

    // Settings Routes (Protected)
    .get(
      path: '/api/settings',
      handler: settingsController.queryHandler,
      responses: SettingsTable.getResponses,
      tag: SettingsTable.kTable,
    ),
    .get(
      path: '/api/settings/<id>',
      handler: settingsController.selectHandler,
      responses: SettingsTable.getResponses,
      tag: SettingsTable.kTable,
    ),
    .get(
      path: '/api/settings/search/<term>',
      handler: settingsController.searchHandler,
      responses: SettingsTable.getResponses,
      tag: SettingsTable.kTable,
    ),
    .post(
      path: '/api/settings',
      handler: settingsController.insertHandler,
      responses: SettingsTable.postResponses,
      requestBody: SettingsTable.requestBody,
      tag: SettingsTable.kTable,
    ),
    .patch(
      path: '/api/settings/<id>',
      handler: settingsController.updateHandler,
      responses: {},
      requestBody: SettingsTable.requestBody,
      tag: SettingsTable.kTable,
    ),
    .delete(
      path: '/api/settings/<id>',
      handler: settingsController.deleteHandler,
      responses: {},
      tag: SettingsTable.kTable,
    ),

    // Exercise Routes (Protected)
    .get(
      path: '/api/exercises',
      handler: exerciseController.queryHandler,
      responses: ExerciseTable.getResponses,
      tag: ExerciseTable.kTable,
    ),
    .get(
      path: '/api/exercises/<id>',
      handler: exerciseController.selectHandler,
      responses: ExerciseTable.getResponses,
      tag: ExerciseTable.kTable,
    ),
    .get(
      path: '/api/exercises/search/<term>',
      handler: exerciseController.searchHandler,
      responses: ExerciseTable.getResponses,
      tag: ExerciseTable.kTable,
    ),
    .post(
      path: '/api/exercises',
      handler: exerciseController.insertHandler,
      responses: ExerciseTable.postResponses,
      requestBody: ExerciseTable.requestBody,
      tag: ExerciseTable.kTable,
    ),
    .patch(
      path: '/api/exercises/<id>',
      handler: exerciseController.updateHandler,
      responses: {},
      requestBody: ExerciseTable.requestBody,
      tag: ExerciseTable.kTable,
    ),
    .delete(
      path: '/api/exercises/<id>',
      handler: exerciseController.deleteHandler,
      responses: {},
      tag: ExerciseTable.kTable,
    ),

    // Prescription Routes (Protected)
    .get(
      path: '/api/prescription',
      handler: prescriptionController.queryHandler,
      responses: PrescriptionTable.getResponses,
      tag: PrescriptionTable.kTable,
    ),
    .get(
      path: '/api/prescription/<id>',
      handler: prescriptionController.selectHandler,
      responses: PrescriptionTable.getResponses,
      tag: PrescriptionTable.kTable,
    ),
    .get(
      path: '/api/prescription/search/<term>',
      handler: prescriptionController.searchHandler,
      responses: PrescriptionTable.getResponses,
      tag: PrescriptionTable.kTable,
    ),
    .post(
      path: '/api/prescription',
      handler: prescriptionController.insertHandler,
      responses: PrescriptionTable.postResponses,
      requestBody: PrescriptionTable.requestBody,
      tag: PrescriptionTable.kTable,
    ),
    .patch(
      path: '/api/prescription/<id>',
      handler: prescriptionController.updateHandler,
      responses: {},
      requestBody: PrescriptionTable.requestBody,
      tag: PrescriptionTable.kTable,
    ),
    .delete(
      path: '/api/prescription/<id>',
      handler: prescriptionController.deleteHandler,
      responses: {},
      tag: PrescriptionTable.kTable,
    ),
  ];
}

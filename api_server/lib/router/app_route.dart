import 'package:shelf/shelf.dart';

class AppRoute {
  const AppRoute({
    required this.method,
    required this.path,
    required this.handler,
    required this.responses,
    this.requestBody,
    this.description,
    this.summary,
    this.public = false,
    this.tag = 'General',
  });

  factory AppRoute.get({
    required String path,
    required Handler handler,
    required String tag,
    required Map<String, dynamic> responses,
    bool public = false,
    String? summary,
    String? description,
  }) => AppRoute(
    method: 'GET',
    path: path,
    handler: handler,
    responses: responses,
    description: description,
    summary: summary,
    public: public,
    tag: tag,
  );

  factory AppRoute.post({
    required String path,
    required Handler handler,
    required String tag,
    required Map<String, dynamic> responses,
    required Map<String, dynamic> requestBody,
    bool public = false,
    String? summary,
    String? description,
  }) => AppRoute(
    method: 'POST',
    path: path,
    handler: handler,
    responses: responses,
    requestBody: requestBody,
    description: description,
    summary: summary,
    public: public,
    tag: tag,
  );

  factory AppRoute.put({
    required String path,
    required Handler handler,
    required String tag,
    required Map<String, dynamic> responses,
    required Map<String, dynamic> requestBody,
    bool public = false,
    String? summary,
    String? description,
  }) => AppRoute(
    method: 'PUT',
    path: path,
    handler: handler,
    responses: responses,
    requestBody: requestBody,
    description: description,
    summary: summary,
    public: public,
    tag: tag,
  );

  factory AppRoute.patch({
    required String path,
    required Handler handler,
    required String tag,
    required Map<String, dynamic> responses,
    required Map<String, dynamic> requestBody,
    bool public = false,
    String? summary,
    String? description,
  }) => AppRoute(
    method: 'PATCH',
    path: path,
    handler: handler,
    responses: responses,
    requestBody: requestBody,
    description: description,
    summary: summary,
    public: public,
    tag: tag,
  );

  factory AppRoute.delete({
    required String path,
    required Handler handler,
    required String tag,
    required Map<String, dynamic> responses,
    bool public = false,
    String? summary,
    String? description,
  }) => AppRoute(
    method: 'DELETE',
    path: path,
    handler: handler,
    responses: responses,
    description: description,
    summary: summary,
    public: public,
    tag: tag,
  );

  final String method;
  final String path; // e.g. /api/users/<id>
  final Handler handler;
  final bool public;
  final String tag;
  final String? summary;
  final String? description;
  final Map<String, dynamic> responses;
  final Map<String, dynamic>? requestBody;
}

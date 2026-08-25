import 'package:shelf/shelf.dart';

class const AppRoute({
  required final String method,
  required final String path, // e.g. /api/users/<id>
  required final Handler handler,
  required final Map<String, dynamic> responses,
  final Map<String, dynamic>? requestBody,
  final String? description,
  final String? summary,
  final bool public = false,
  final String tag = 'General',
}) {
  factory get({
    required String path,
    required Handler handler,
    required String tag,
    required Map<String, dynamic> responses,
    bool public = false,
    String? summary,
    String? description,
  }) => .new(
    method: 'GET',
    path: path,
    handler: handler,
    responses: responses,
    description: description,
    summary: summary,
    public: public,
    tag: tag,
  );

  factory post({
    required String path,
    required Handler handler,
    required String tag,
    required Map<String, dynamic> responses,
    required Map<String, dynamic> requestBody,
    bool public = false,
    String? summary,
    String? description,
  }) => .new(
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

  factory put({
    required String path,
    required Handler handler,
    required String tag,
    required Map<String, dynamic> responses,
    required Map<String, dynamic> requestBody,
    bool public = false,
    String? summary,
    String? description,
  }) => .new(
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

  factory patch({
    required String path,
    required Handler handler,
    required String tag,
    required Map<String, dynamic> responses,
    required Map<String, dynamic> requestBody,
    bool public = false,
    String? summary,
    String? description,
  }) => .new(
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

  factory delete({
    required String path,
    required Handler handler,
    required String tag,
    required Map<String, dynamic> responses,
    bool public = false,
    String? summary,
    String? description,
  }) => .new(
    method: 'DELETE',
    path: path,
    handler: handler,
    responses: responses,
    description: description,
    summary: summary,
    public: public,
    tag: tag,
  );
}

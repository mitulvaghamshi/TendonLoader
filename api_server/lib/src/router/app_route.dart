import 'package:shelf/shelf.dart';

class AppRoute {
  const AppRoute(
    this.method,
    this.path,
    this.handler, {
    this.summary,
    this.description,
    this.public = false,
    this.tag = 'General',
  });

  factory AppRoute.get({
    required String path,
    required Handler handler,
    required String tag,
    bool public = false,
    String? summary,
    String? description,
  }) => AppRoute(
    'GET',
    path,
    handler,
    public: public,
    tag: tag,
    summary: summary,
    description: description,
  );

  factory AppRoute.post({
    required String path,
    required Handler handler,
    required String tag,
    bool public = false,
    String? summary,
    String? description,
  }) => AppRoute(
    'POST',
    path,
    handler,
    public: public,
    tag: tag,
    summary: summary,
    description: description,
  );

  factory AppRoute.put({
    required String path,
    required Handler handler,
    required String tag,
    bool public = false,
    String? summary,
    String? description,
  }) => AppRoute(
    'PUT',
    path,
    handler,
    public: public,
    tag: tag,
    summary: summary,
    description: description,
  );

  factory AppRoute.patch({
    required String path,
    required Handler handler,
    required String tag,
    bool public = false,
    String? summary,
    String? description,
  }) => AppRoute(
    'PATCH',
    path,
    handler,
    public: public,
    tag: tag,
    summary: summary,
    description: description,
  );

  factory AppRoute.delete({
    required String path,
    required Handler handler,
    required String tag,
    bool public = false,
    String? summary,
    String? description,
  }) => AppRoute(
    'DELETE',
    path,
    handler,
    public: public,
    tag: tag,
    summary: summary,
    description: description,
  );

  final String method;
  final String path; // e.g. /api/users/<id>
  final Handler handler;
  final bool public;
  final String tag;
  final String? summary;
  final String? description;
}

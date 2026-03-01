import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';

/// Using [highlight.js] syntax coloring theme.
enum Syntax {
  agate('agate'),
  arta('arta'),
  monokai('monokai'),
  nord('nord'),
  obsidian('obsidian'),
  tomorrowNight('tomorrow-night');

  const Syntax(this.theme);

  final String theme;
}

/// Controls the default expansion setting.
enum Expansion {
  list, // expands only tags
  full, // expands tags and operations
  none, // expands nothing
}

/// Type of schema (YAML/JSON).
enum SpecType { yaml, json }

/// This class sets all the default attributes to start swagger-ui.
///
/// // Example:
/// ```dart
/// final swaggerHandler = SwaggerUI.fromFile(
///   File('schema.yaml'),
///   title: 'ABC Api',
///   deepLink: true,
/// );
/// await io.serve(swaggerHandler, '0.0.0.0', 3002);
///```
class SwaggerUI {
  const SwaggerUI(
    this.schema, {
    this.title = 'Swagger UI',
    this.deepLink = false,
    this.syntax = .agate,
    this.expansion = .list,
    this.persistAuth = false,
    this.specType = .json,
  });

  FutureOr<Response> call(Request request) => .ok(
    _generateBody,
    headers: {HttpHeaders.contentTypeHeader: ContentType.html.value},
  );

  /// Schema (YAML/JSON) content.
  final String schema;

  /// Title for browser tab.
  final String title;

  /// Reference each node in the url (e.g.: /swagger/#/post).
  final bool deepLink;

  /// Highlight.js syntax highliting to use.
  final Syntax syntax;

  /// Controls expansion setting for the operations and tags.
  final Expansion expansion;

  /// Persists authorization between close/refresh.
  final bool persistAuth;

  /// Type Schema (YAML/JSON).
  final SpecType specType;
}

extension SwaggerUiNew on SwaggerUI {
  static Future<SwaggerUI> fromFile({
    required String path,
    String title = 'Swagger UI',
    bool deepLink = false,
    Expansion expansion = .list,
    Syntax syntax = .agate,
    bool persistAuth = false,
  }) async => .new(
    await File(path).readAsString(),
    title: title,
    deepLink: deepLink,
    expansion: expansion,
    syntax: syntax,
    persistAuth: persistAuth,
    specType: path.endsWith('.yaml') ? .yaml : .json,
  );
}

extension on SwaggerUI {
  String get _generateBody =>
      '''
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="description" content="API documentation for $title." />
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5.32.0/swagger-ui.css" />
  <title>$title</title>
</head>

<body>
  <div id="swagger-ui"></div>
</body>

<script src="https://cdn.jsdelivr.net/npm/js-yaml@4.1.1/dist/js-yaml.min.js"></script>
<script src="https://unpkg.com/swagger-ui-dist@5.32.0/swagger-ui-bundle.js" crossorigin></script>

<script>
  window.onload = () => {
    const spec = ${specType == .yaml ? "jsyaml.load(`$schema`);" : "$schema;"}
    window.ui = SwaggerUIBundle({
      spec: spec,
      dom_id: '#swagger-ui',
      deepLinking: $deepLink,
      docExpansion: '${expansion.name}',
      syntaxHighlight: { activate: true, theme: '${syntax.theme}' },
      persistAuthorization: $persistAuth,
    });
  };
</script>

</html>
''';
}

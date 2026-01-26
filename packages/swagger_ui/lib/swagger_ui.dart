library;

import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';

/// Highlight.js syntax coloring theme to use. (Only these 6 styles are available).
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

/// Controls the default expansion setting for the operations and tags.
enum Expansion {
  /// expands only the tags
  list,

  /// expands the tags and operations
  full,

  /// expands nothing
  none,
}

/// Type of schema (YAML/JSON).
enum SpecType { yaml, json }

/// This class starts all the default attributes to start swagger-ui.
/// In addition to receiving the Spec (YAML/JSON)
/// it is also possible to configure the title and enable "deepLink".
///
/// [fileSchemaPath]: Schema path (YAML/JSON).
/// [title]: Defines the title that is visible in the browser tab.
/// [docExpansion]: (Default DocExpansion.list), Controls the default expansion setting for the operations and tags. It can be 'list' (expands only the tags), 'full' (expands the tags and operations) or 'none' (expands nothing).
/// [deepLink]: (Default true) enables the use of deep-links to reference each node in the url (ex: /swagger/#/post).
/// [syntaxHighlightTheme]: (Default SyntaxHighlightTheme.agate) Highlight.js syntax coloring theme to use. (Only these 6 styles are available).
/// [persistAuthorization]: (Default false) If set to true, it persists authorization data and it would not be lost on browser close/refresh.
///
/// Example:
///
/// ```dart
/// final swaggerHandler = SwaggerUI.fromFile(
///   File('swagger/swagger.yaml'),
///   title: 'Swagger API',
///   deepLink: true,
/// );
///
/// final server = await io.serve(swaggerHandler, '0.0.0.0', 4000);
///```
class SwaggerUI {
  /// Schema text (YAML/JSON).
  final String schema;

  /// Defines the title that is visible in the browser tab.
  final String title;

  /// (Default false) enables the use of deep-links to reference each node in the url (ex: /swagger/#/post).
  final bool deepLink;

  /// Highlight.js syntax coloring theme to use. (Only these 6 styles are available).
  final Syntax syntax;

  /// Controls the default expansion setting for the operations and tags.
  final Expansion expansion;

  /// If set to true, it persists authorization data and it would not be lost on browser close/refresh
  final bool persistAuth;

  /// Type Schema (YAML/JSON).
  final SpecType specType;

  const SwaggerUI(
    this.schema, {
    this.title = 'Swagger UI',
    this.deepLink = false,
    this.syntax = .agate,
    this.expansion = .list,
    this.persistAuth = false,
    this.specType = .json,
  });

  static Future<SwaggerUI> fromFile({
    required String path,
    String title = 'Swagger UI',
    bool deepLink = false,
    Expansion expansion = .list,
    Syntax syntax = .agate,
    bool persistAuth = false,
  }) async => SwaggerUI(
    await File(path).readAsString(),
    title: title,
    deepLink: deepLink,
    expansion: expansion,
    syntax: syntax,
    persistAuth: persistAuth,
    specType: path.endsWith('.yaml') ? .yaml : .json,
  );

  FutureOr<Response> call(Request request) {
    final spec = specType == .yaml
        ? "const spec = jsyaml.load(`$schema`);"
        : "const spec = $schema;";
    final body =
        '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta
    name="description"
    content="SwaggerUI"
  />
  <title>$title</title>
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui.css" />
</head>
<body>
<div id="swagger-ui"></div>
<script src="https://cdn.jsdelivr.net/npm/js-yaml@4.1.0/dist/js-yaml.min.js"></script>
<script src="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui-bundle.js" crossorigin></script>

<script>
  window.onload = () => {
  $spec
    window.ui = SwaggerUIBundle({
      dom_id: '#swagger-ui',
      docExpansion: '${expansion.name}',
      deepLinking: $deepLink,
      spec: spec,
      syntaxHighlight: {
        activate: true,
        theme: '${syntax.theme}',
      },
      persistAuthorization: $persistAuth,
    });
  };
</script>
</body>
</html>
''';
    return .ok(
      body,
      headers: {HttpHeaders.contentTypeHeader: ContentType.html.value},
    );
  }
}

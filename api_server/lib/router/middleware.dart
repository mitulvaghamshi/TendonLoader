import 'dart:io';

import 'package:api_server/api_server.dart';
import 'package:api_server/service/user_service.dart';
import 'package:shelf/shelf.dart';

Middleware checkAuth(UserService service) => (handler) {
  return (request) {
    final authHeader = request.headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return .unauthorized('Missing or Invalid Token\n');
    }
    final token = authHeader.substring(7);
    final result = service.authorize(token);
    if (result.data case final User user) {
      final updatedRequest = request.change(context: {'user': user});
      return handler(updatedRequest);
    }
    return .unauthorized('Invalid Token\n');
  };
};

Middleware checkRole(List<String> roles) => (handler) {
  return (request) {
    final user = request.context['user'] as User?;
    if (user == null) {
      return .unauthorized('User not found in context\n');
    }
    if (roles.isNotEmpty && !roles.contains(user.role)) {
      return .forbidden('Insufficient Permissions\n');
    }
    return handler(request);
  };
};

Middleware cors([Map<String, dynamic> options = const {}]) => (handler) {
  final defaultOptions = <String, dynamic>{
    'origins': <String>[],
    'credentials': true,
    'methods': ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    'headers': ['Content-Type', 'Authorization'],
    'maxAge': 8640,
  }..updateAll((key, value) => options[key] ?? value);

  final origins = defaultOptions['origins'] as List<String>;
  final credentials = defaultOptions['credentials'] as bool;
  final methods = defaultOptions['methods'] as List<String>;
  final headers = defaultOptions['headers'] as List<String>;
  final maxAge = defaultOptions['maxAge'] as int;

  return (request) {
    final origin = request.headers['origin']!;
    final newHeaders = {
      HttpHeaders.accessControlAllowMethodsHeader: methods.join(','),
      HttpHeaders.accessControlAllowHeadersHeader: headers.join(','),
    };
    // Validate origin
    if (origins.contains(origin)) {
      newHeaders.addAll({
        HttpHeaders.accessControlAllowOriginHeader: origin,
        HttpHeaders.varyHeader: 'Origin',
        if (credentials)
          HttpHeaders.accessControlAllowCredentialsHeader: 'true',
      });
    }
    // Handle preflight
    if (request.method.toUpperCase() == 'OPTIONS') {
      newHeaders.addAll({
        HttpHeaders.accessControlMaxAgeHeader: maxAge.toString(),
      });
      return Response(204);
    }
    return handler(request.change(headers: newHeaders));
  };
};

import 'package:api_server/api_server.dart';
import 'package:api_server/src/services/user_service.dart';
import 'package:shelf/shelf.dart';

class AuthMiddleware {
  const AuthMiddleware(this.userService);

  final UserService userService;
}

extension AuthMiddlewareExt on AuthMiddleware {
  Middleware get checkAuthentication => (handler) {
    return (request) async {
      final authHeader = request.headers['Authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return .unauthorized('Missing or Invalid Token\n');
      }
      final token = authHeader.substring(7);
      final result = userService.authorize(token);
      if (result.data case User user) {
        final updatedRequest = request.change(context: {'user': user});
        return handler(updatedRequest);
      }
      return .unauthorized('Invalid Token\n');
    };
  };

  Middleware checkRole(List<String> roles) => (handler) {
    return (request) async {
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
}

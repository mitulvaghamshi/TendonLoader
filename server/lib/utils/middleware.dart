import 'package:server/models/user.dart';
import 'package:server/services/user_service.dart';
import 'package:server/utils/snapshot.dart';
import 'package:shelf/shelf.dart';

class AuthMiddleware {
  const AuthMiddleware(this.userService);

  final UserService userService;

  Middleware get checkAuthentication => (innerHandler) {
    return (request) async {
      final authHeader = request.headers['Authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.unauthorized('Missing or Invalid Token');
      }
      final token = authHeader.substring(7);
      final result = userService.authorize(token);

      if (result.data case User user) {
        final updatedRequest = request.change(context: {'user': user});
        return innerHandler(updatedRequest);
      }

      return Response.unauthorized('Invalid Token');
    };
  };

  Middleware checkRole(List<String> allowedRoles) => (innerHandler) {
    return (request) async {
      final user = request.context['user'] as User?;
      if (user == null) {
        return Response.unauthorized('User not found in context');
      }
      if (allowedRoles.isNotEmpty && !allowedRoles.contains(user.role)) {
        return Response.forbidden('Insufficient Permissions');
      }
      return innerHandler(request);
    };
  };
}

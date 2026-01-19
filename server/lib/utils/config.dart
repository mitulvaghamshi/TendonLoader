import 'package:server/controllers/exercise_controller.dart';
import 'package:server/controllers/prescription_controller.dart';
import 'package:server/controllers/settings_controller.dart';
import 'package:server/controllers/user_controller.dart';
import 'package:server/services/exercise_service.dart';
import 'package:server/services/prescription_service.dart';
import 'package:server/services/settings_service.dart';
import 'package:server/services/user_service.dart';
import 'package:server/utils/app_router.dart' as v1;
import 'package:sqlite3/sqlite3.dart';
import 'package:uuid/uuid.dart';

class Config {
  const Config._({required this.database, required this.router});

  factory Config.create(String dbPath) {
    assert(dbPath.isNotEmpty, 'Database path cannot be empty');
    final db = sqlite3.open(dbPath);
    final appRouter = v1.AppRouter(
      userController: UserController(UserService(db)..init()),
      settingsController: SettingsController(SettingsService(db)),
      exerciseController: ExerciseController(ExerciseService(db)),
      prescriptionController: PrescriptionController(PrescriptionService(db)),
    );

    return Config._(database: db, router: appRouter);
  }

  final Database database;
  final v1.AppRouter router;

  static const uuid = Uuid();
}

// Response.notFound(
//   jsonEncode({
//     'status': 'FAILED',
//     'data': {'error': "Parameter ':workoutId' cannot be empty"},
//   }),
// );

// Response.ok(
//   jsonEncode({
//     'status': 'OK',
//     'data': 'recordService.getRecordForWorkout(workoutId)',
//   }),
// );

// Response.badRequest(
//   body: jsonEncode({
//     'status': 'FAILED',
//     'data': {'error': 'error?.massage || error'},
//   }),
// );

import 'package:tendon_loader/utils/app/constants.dart' show Keys;

class Prescription {
  Prescription({this.sets, this.reps, this.holdTime, this.restTime, this.targetLoad});

  Prescription.fromMap(Map<dynamic, dynamic> map) {
    sets = int.parse(map[Keys.KEY_SETS].toString());
    reps = int.parse(map[Keys.KEY_REPS].toString());
    lastMVC = double.parse(map[Keys.KEY_LAST_MVC].toString());
    holdTime = int.parse(map[Keys.KEY_HOLD_TIME].toString());
    restTime = int.parse(map[Keys.KEY_REST_TIME].toString());
    targetLoad = double.parse(map[Keys.KEY_TARGET_LOAD].toString());
  }

  int sets;
  int reps;
  int holdTime;
  int restTime;
  double lastMVC;
  double targetLoad;

  Map<String, String> toMap() {
    return <String, String>{
      Keys.KEY_SETS: sets.toString(),
      Keys.KEY_REPS: reps.toString(),
      Keys.KEY_LAST_MVC: lastMVC.toString(),
      Keys.KEY_HOLD_TIME: holdTime.toString(),
      Keys.KEY_REST_TIME: restTime.toString(),
      Keys.KEY_TARGET_LOAD: targetLoad.toString(),
    };
  }
}

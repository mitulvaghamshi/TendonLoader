import 'package:tendon_loader/utils/app/constants.dart' show Keys;

class ExerciseData {
  ExerciseData({this.sets, this.reps, this.holdTime, this.restTime, this.targetLoad});

  ExerciseData.fromMap(Map<dynamic, dynamic> map) {
    sets = int.parse(map[Keys.keySets].toString());
    reps = int.parse(map[Keys.keyReps].toString());
    lastMVC = double.parse(map[Keys.keyLastMVC].toString());
    holdTime = int.parse(map[Keys.keyHoldTime].toString());
    restTime = int.parse(map[Keys.keyRestTime].toString());
    targetLoad = double.parse(map[Keys.keyTargetLoad].toString());
  }

  int sets;
  int reps;
  int holdTime;
  int restTime;
  double lastMVC;
  double targetLoad;

  Map<String, String> toMap() {
    return <String, String>{
      Keys.keySets: sets.toString(),
      Keys.keyReps: reps.toString(),
      Keys.keyLastMVC: lastMVC.toString(),
      Keys.keyHoldTime: holdTime.toString(),
      Keys.keyRestTime: restTime.toString(),
      Keys.keyTargetLoad: targetLoad.toString(),
    };
  }
}

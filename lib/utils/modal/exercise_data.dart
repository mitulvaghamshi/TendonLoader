import 'package:tendon_loader/utils/modal/chart_data.dart';

class ExerciseData {
  ExerciseData({
    this.collection = const <ChartData>[],
    this.sets,
    this.reps,
    this.holdTime,
    this.restTime,
    this.targetLoad,
    this.isComplete,
    this.progressorId,
  });

  ExerciseData.fromMap(Map<dynamic, dynamic> map) {
    sets = int.parse(map['sets'].toString());
    reps = int.parse(map['reps'].toString());
    holdTime = int.parse(map['holdTime'].toString());
    restTime = int.parse(map['restTime'].toString());
    targetLoad = double.parse(map['targetLoad'].toString());
    isComplete = map['isComplete'] as bool;
    progressorId = map['progressorId'] as String;
  }

  int sets;
  int reps;
  int holdTime;
  int restTime;
  bool isComplete;
  double targetLoad;
  String progressorId;
  List<ChartData> collection;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['sets'] = sets;
    map['reps'] = reps;
    map['holdTime'] = holdTime;
    map['restTime'] = restTime;
    map['targetLoad'] = targetLoad;
    map['isComplete'] = isComplete;
    map['progressorId'] = progressorId;
    map['data'] = collection.map((ChartData data) => data.toMap()).toList();
    return map;
  }
}

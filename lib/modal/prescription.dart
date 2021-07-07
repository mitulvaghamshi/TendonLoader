import 'package:hive/hive.dart';
import 'package:tendon_loader/constants/keys.dart';

part 'prescription.g.dart';

@HiveType(typeId: 3)
class Prescription extends HiveObject {
  Prescription({
    this.sets = 0,
    this.reps = 0,
    this.setRest = 0,
    this.holdTime = 0,
    this.restTime = 0,
    this.targetLoad = 0,
    this.mvcDuration = 0,
  });

  Prescription.empty() : this();

  Prescription.fromJson(Map<String, dynamic> map)
      : this(
            sets: int.parse(map[keySets].toString()),
            reps: int.parse(map[keyReps].toString()),
            setRest: int.parse(map[keySetRest].toString()),
            restTime: int.parse(map[keyRestTime].toString()),
            holdTime: int.parse(map[keyHoldTime].toString()),
            targetLoad: double.parse(map[keyTargetLoad].toString()),
            mvcDuration: int.parse(map[keyMvcDuration].toString()));

  @HiveField(0)
  final int sets;
  @HiveField(1)
  final int reps;
  @HiveField(2)
  final int setRest;
  @HiveField(3)
  final int holdTime;
  @HiveField(4)
  final int restTime;
  @HiveField(5)
  final int mvcDuration;
  @HiveField(6)
  final double targetLoad;

  Map<String, num> toMap() {
    return <String, num>{
      keySets: sets,
      keyReps: reps,
      keySetRest: setRest,
      keyHoldTime: holdTime,
      keyRestTime: restTime,
      keyTargetLoad: targetLoad,
      keyMvcDuration: mvcDuration,
    };
  }
}

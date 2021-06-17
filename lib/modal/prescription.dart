import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/constants.dart';
 
@immutable
class Prescription {
  const Prescription({
    required this.sets,
    required this.reps,
    required this.holdTime,
    required this.restTime,
    required this.targetLoad,
    this.setRest = 90,
  });

  Prescription.fromMap(Map<String, dynamic> map)
      : this(
          sets: int.parse(map[keySets].toString()),
          reps: int.parse(map[keyReps].toString()),
          holdTime: int.parse(map[keyHoldTime].toString()),
          restTime: int.parse(map[keyRestTime].toString()),
          targetLoad: double.parse(map[keyTargetLoad].toString()),
          setRest: int.parse(map[keySetRest].toString()),
        );

  final int sets;
  final int reps;
  final int holdTime;
  final int restTime;
  final int setRest;
  final double targetLoad;

  Map<String, num> toMap() {
    return <String, num>{
      keySets: sets,
      keyReps: reps,
      keyHoldTime: holdTime,
      keyRestTime: restTime,
      keyTargetLoad: targetLoad,
      keySetRest: setRest,
    };
  }
}

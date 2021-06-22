import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/keys.dart';

@immutable
class Prescription {
  const Prescription({
    required this.sets,
    required this.reps,
    required this.holdTime,
    required this.restTime,
    required this.targetLoad,
    this.mvcDuration = 5,
    this.setRest = 90,
  });

  Prescription.fromJson(Map<String, dynamic> map)
      : this(
            sets: int.parse(map[keySets].toString()),
            reps: int.parse(map[keyReps].toString()),
            setRest: int.parse(map[keySetRest].toString()),
            restTime: int.parse(map[keyRestTime].toString()),
            holdTime: int.parse(map[keyHoldTime].toString()),
            targetLoad: double.parse(map[keyTargetLoad].toString()),
            mvcDuration: int.tryParse(map[keyMvcDuration].toString()));

  final int sets;
  final int reps;
  final int setRest;
  final int holdTime;
  final int restTime;
  final int? mvcDuration;
  final double targetLoad;

  Map<String, num> toMap() {
    return <String, num>{
      keySets: sets,
      keyReps: reps,
      keySetRest: setRest,
      keyHoldTime: holdTime,
      keyRestTime: restTime,
      keyTargetLoad: targetLoad,
      keyMvcDuration: mvcDuration!,
    };
  }
}

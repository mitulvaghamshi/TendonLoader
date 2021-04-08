import 'package:flutter/material.dart';

@immutable
class ExerciseData {
  const ExerciseData({this.sets, this.reps, this.holdTime, this.restTime, this.targetLoad});

  final int sets;
  final int reps;
  final int holdTime;
  final int restTime;
  final double targetLoad;
}

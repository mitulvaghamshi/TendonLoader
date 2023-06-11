import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tendon_loader/utils.dart';

class Prescription {
  Prescription({
    required this.sets,
    required this.reps,
    required this.setRest,
    required this.holdTime,
    required this.restTime,
    required this.targetLoad,
    required this.mvcDuration,
    this.isAdmin,
  });

  factory Prescription.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
          SnapshotOptions? _) =>
      Prescription.fromMap(snapshot.data()!);

  factory Prescription.fromMap(Map<String, dynamic> data) => Prescription(
        sets: int.parse(data[keySets].toString()),
        reps: int.parse(data[keyReps].toString()),
        setRest: int.parse(data[keySetRest].toString()),
        restTime: int.parse(data[keyRestTime].toString()),
        holdTime: int.parse(data[keyHoldTime].toString()),
        targetLoad: double.parse(data[keyTargetLoad].toString()),
        mvcDuration: int.parse(data[keyMvcDuration].toString()),
        isAdmin: data[keyIsAdmin] as bool?,
        // isAdmin: (data[keyIsAdmin] as String) == 'true',
      );

  final int sets;
  final int reps;
  final int setRest;
  final int holdTime;
  final int restTime;
  final int mvcDuration;
  final double targetLoad;
  bool? isAdmin;

  Map<String, dynamic> toMap() => <String, dynamic>{
        keySets: sets,
        keyReps: reps,
        keySetRest: setRest,
        keyHoldTime: holdTime,
        keyRestTime: restTime,
        keyTargetLoad: targetLoad,
        keyMvcDuration: mvcDuration,
        keyIsAdmin: isAdmin
      };
}

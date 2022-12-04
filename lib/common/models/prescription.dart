import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/common/constants.dart';

part 'prescription.g.dart';

@HiveType(typeId: 2)
class Prescription extends HiveObject {
  Prescription({
    required this.sets,
    required this.reps,
    required this.setRest,
    required this.holdTime,
    required this.restTime,
    required this.targetLoad,
    required this.mvcDuration,
    required this.isAdmin,
  });

  factory Prescription.empty({bool isAdmin = false}) {
    return Prescription(
      sets: 0,
      reps: 0,
      setRest: 90,
      holdTime: 0,
      restTime: 0,
      targetLoad: 0,
      mvcDuration: 0,
      isAdmin: isAdmin,
    );
  }

  factory Prescription.fromJson(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    final Map<String, dynamic>? data = snapshot.data();
    if (data == null) throw 'Json response is null!';
    return Prescription.fromMap(data);
  }

  factory Prescription.fromMap(Map<String, dynamic> data) {
    return Prescription(
      sets: int.parse(data[DataKeys.sets].toString()),
      reps: int.parse(data[DataKeys.reps].toString()),
      setRest: int.parse(data[DataKeys.setRest].toString()),
      restTime: int.parse(data[DataKeys.restTime].toString()),
      holdTime: int.parse(data[DataKeys.holdTime].toString()),
      targetLoad: double.parse(data[DataKeys.targetLoad].toString()),
      mvcDuration: int.parse(data[DataKeys.mvcDuration].toString()),
      isAdmin: data[DataKeys.isAdmin] as bool? ?? false,
    );
  }

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
  @HiveField(7)
  final bool isAdmin;
}

extension ExPrescription on Prescription {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      DataKeys.sets: sets,
      DataKeys.reps: reps,
      DataKeys.setRest: setRest,
      DataKeys.holdTime: holdTime,
      DataKeys.restTime: restTime,
      DataKeys.targetLoad: targetLoad,
      DataKeys.mvcDuration: mvcDuration,
      DataKeys.isAdmin: isAdmin,
    };
  }

  Prescription copyWith({
    int? sets,
    int? reps,
    int? setRest,
    int? holdTime,
    int? restTime,
    double? targetLoad,
    int? mvcDuration,
    bool? isAdmin,
  }) {
    return Prescription(
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      setRest: setRest ?? this.setRest,
      holdTime: holdTime ?? this.holdTime,
      restTime: restTime ?? this.restTime,
      targetLoad: targetLoad ?? this.targetLoad,
      mvcDuration: mvcDuration ?? this.mvcDuration,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}

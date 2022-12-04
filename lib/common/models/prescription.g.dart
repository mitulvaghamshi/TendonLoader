// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionAdapter extends TypeAdapter<Prescription> {
  @override
  final int typeId = 2;

  @override
  Prescription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prescription(
      sets: fields[0] as int,
      reps: fields[1] as int,
      setRest: fields[2] as int,
      holdTime: fields[3] as int,
      restTime: fields[4] as int,
      targetLoad: fields[6] as double,
      mvcDuration: fields[5] as int,
      isAdmin: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Prescription obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.sets)
      ..writeByte(1)
      ..write(obj.reps)
      ..writeByte(2)
      ..write(obj.setRest)
      ..writeByte(3)
      ..write(obj.holdTime)
      ..writeByte(4)
      ..write(obj.restTime)
      ..writeByte(5)
      ..write(obj.mvcDuration)
      ..writeByte(6)
      ..write(obj.targetLoad)
      ..writeByte(7)
      ..write(obj.isAdmin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

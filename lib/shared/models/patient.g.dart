// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientAdapter extends TypeAdapter<Patient> {
  @override
  final int typeId = 4;

  @override
  Patient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Patient(
      exports: (fields[0] as List?)?.cast<Export>(),
      userRef: fields[4] as DocumentReference<Map<String, dynamic>>?,
      exportRef: fields[2] as CollectionReference<Export>?,
      prescription: fields[1] as Prescription?,
      prescriptionRef: fields[3] as DocumentReference<Prescription>?,
    );
  }

  @override
  void write(BinaryWriter writer, Patient obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.exports)
      ..writeByte(1)
      ..write(obj.prescription)
      ..writeByte(2)
      ..write(obj.exportRef)
      ..writeByte(3)
      ..write(obj.prescriptionRef)
      ..writeByte(4)
      ..write(obj.userRef);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

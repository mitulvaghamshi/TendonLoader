// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExportAdapter extends TypeAdapter<Export> {
  @override
  final int typeId = 2;

  @override
  Export read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Export(
      userId: fields[0] as String?,
      mvcValue: fields[2] as double?,
      reference: fields[7] as DocumentReference<Map<String, dynamic>>?,
      prescription: fields[6] as Prescription?,
      timestamp: fields[3] as Timestamp,
      isComplate: fields[1] as bool,
      exportData: (fields[5] as List).cast<ChartData>(),
      progressorId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Export obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.isComplate)
      ..writeByte(2)
      ..write(obj.mvcValue)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.progressorId)
      ..writeByte(5)
      ..write(obj.exportData)
      ..writeByte(6)
      ..write(obj.prescription)
      ..writeByte(7)
      ..write(obj.reference);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

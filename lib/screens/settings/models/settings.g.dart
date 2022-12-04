// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 1;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      darkMode: fields[0] as bool,
      autoUpload: fields[1] as bool,
      customPrescriptions: fields[2] as bool,
      graphScale: fields[3] as double,
      userId: fields[4] as String?,
      prescription: fields[5] as Prescription,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.darkMode)
      ..writeByte(1)
      ..write(obj.autoUpload)
      ..writeByte(2)
      ..write(obj.customPrescriptions)
      ..writeByte(3)
      ..write(obj.graphScale)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.prescription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

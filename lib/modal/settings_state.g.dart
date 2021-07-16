// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsStateAdapter extends TypeAdapter<SettingsState> {
  @override
  final int typeId = 5;

  @override
  SettingsState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsState(
      autoUpload: fields[0] as bool?,
      graphSize: fields[1] as double?,
      customPrescriptions: fields[2] as bool?,
      lastDuration: fields[3] as int?,
      lastPrescriptions: fields[4] as Prescription?,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsState obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.autoUpload)
      ..writeByte(1)
      ..write(obj.graphSize)
      ..writeByte(2)
      ..write(obj.customPrescriptions)
      ..writeByte(3)
      ..write(obj.lastDuration)
      ..writeByte(4)
      ..write(obj.lastPrescriptions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

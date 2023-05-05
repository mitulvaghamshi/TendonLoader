// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chartdata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChartDataAdapter extends TypeAdapter<ChartData> {
  @override
  final int typeId = 1;

  @override
  ChartData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartData(
      time: fields[0] as double,
      load: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ChartData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.load);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

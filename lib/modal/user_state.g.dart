// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStateAdapter extends TypeAdapter<UserState> {
  @override
  final int typeId = 6;

  @override
  UserState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserState(
      firstRun: fields[1] as bool?,
      keepSigned: fields[2] as bool?,
      userName: fields[3] as String?,
      passWord: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserState obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.firstRun)
      ..writeByte(2)
      ..write(obj.keepSigned)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.passWord);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
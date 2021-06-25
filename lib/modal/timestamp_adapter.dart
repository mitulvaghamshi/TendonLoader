import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class TimestampAdapter extends TypeAdapter<Timestamp> {
  @override
  final typeId = 7;

  @override
  Timestamp read(BinaryReader reader) {
    var millis = reader.readInt();
    return Timestamp.fromMillisecondsSinceEpoch(millis);
  }

  @override
  void write(BinaryWriter writer, Timestamp obj) {
    writer.writeInt(obj.millisecondsSinceEpoch);
  }
}

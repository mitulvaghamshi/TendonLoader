import 'dart:typed_data';

extension ExTimer on int {
  String get toTime => this == 0 ? 'GO!' : '${this ~/ 60}:${(this % 60).toString().padLeft(2, '0')}';
}

extension ExTimeFormat on double {
  String get toTime => '🕒 ${this ~/ 60}:${(this % 60).toStringAsFixed(0).padLeft(2, '0')} Sec';

  String get toRemaining => '⏱ ${(5 - this).toStringAsFixed(1)} Sec';
}

extension ExConvert on List<int> {
  double get toWeight => double.parse(
      (Uint8List.fromList(this).buffer.asByteData().getFloat32(0, Endian.little).abs()).toStringAsFixed(2));

  double get toTime => double.parse(
      (Uint8List.fromList(this).buffer.asByteData().getUint32(0, Endian.little) / 1000000.0).toStringAsFixed(1));
}

import 'package:flutter/foundation.dart';

@immutable
class ChartData {
  const ChartData({this.time = 0, this.load = 0});

  factory ChartData.fromPair(String data) {
    final items = data.split(':');
    return ChartData(time: .parse(items[0]), load: .parse(items[1]));
  }

  final double time;
  final double load;
}

extension Utils on ChartData {
  String get pair => '$time:$load';

  ChartData copyWith({double? time, double? load}) {
    return ChartData(time: time ?? this.time, load: load ?? this.load);
  }
}

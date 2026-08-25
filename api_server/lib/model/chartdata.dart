class const ChartData({final double time = 0, final double load = 0}) {
  factory fromPair(String data) {
    final items = data.split(':');
    return .new(time: .parse(items[0]), load: .parse(items[1]));
  }
}

extension ChartDataExt on ChartData {
  String get pair => '$time:$load';

  ChartData copyWith({double? time, double? load}) {
    return .new(time: time ?? this.time, load: load ?? this.load);
  }
}

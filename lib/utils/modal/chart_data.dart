import 'dart:convert';

class ChartData {
  ChartData({this.x, this.time, this.load});

  ChartData.fromString(String rawString) {
    final Map<String, dynamic> map = jsonDecode(rawString) as Map<String, dynamic>;
    time = map['time'] as double;
    load = map['load'] as double;
  }

  int x;
  double time;
  double load;

  String toLocalString() => '$time,$load';
}

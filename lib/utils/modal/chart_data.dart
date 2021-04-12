import 'package:flutter/material.dart';

@immutable
class ChartData {
  const ChartData({this.x, this.time, this.load});

  final int x;
  final double time;
  final double load;

  Map<String, double> toMap() => <String, double>{'time': time, 'load': load};
}

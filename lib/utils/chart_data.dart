import 'package:flutter/material.dart';

@immutable
class ChartData {
  const ChartData({this.x, this.time, this.weight});

  final int x;
  final int time;
  final double weight;
}

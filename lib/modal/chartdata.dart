import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/keys.dart';
 
@immutable
class ChartData {
  const ChartData({this.time = 0, this.load = 0});

  ChartData.fromJson(String data) : this.fromMap(jsonDecode(data) as Map<String, dynamic>);

  ChartData.fromMap(Map<String, dynamic> map) : this(time: map[keyChartX] as double?, load: map[keyChartY] as double?);

  ChartData.fromEntry(MapEntry<String, dynamic> entry)
      : this(time: double.parse(entry.key), load: double.parse(entry.value.toString()));

  final double? time;
  final double? load;

  @override
  String toString() => '$time,$load';
}

/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:tendon_loader/utils/constants.dart';

part 'chartdata.g.dart';

@HiveType(typeId: 1)
class ChartData extends HiveObject {
  ChartData({this.time = 0, this.load = 0});

  ChartData.fromJson(String data)
      : this.fromMap(jsonDecode(data) as Map<String, dynamic>);

  ChartData.fromMap(Map<String, dynamic> map)
      : this(
          time: map[keyChartX] as double,
          load: map[keyChartY] as double,
        );

  ChartData.fromEntry(MapEntry<String, dynamic> entry)
      : this(
          time: double.parse(entry.key),
          load: double.parse(entry.value.toString()),
        );

  Map<String, double> toMap() => <String, double>{'$time': load};

  @HiveField(0)
  final double time;
  @HiveField(1)
  final double load;
}

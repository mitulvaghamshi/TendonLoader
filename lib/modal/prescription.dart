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

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/custom/custom_table.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

part 'prescription.g.dart';

@HiveType(typeId: 3)
class Prescription extends HiveObject {
  Prescription({
    required this.sets,
    required this.reps,
    required this.setRest,
    required this.holdTime,
    required this.restTime,
    required this.targetLoad,
    required this.mvcDuration,
    this.isAdmin,
  });

  Prescription.empty()
      : this(
          sets: 0,
          reps: 0,
          setRest: 90,
          holdTime: 0,
          restTime: 0,
          targetLoad: 0,
          mvcDuration: 0,
        );

  Prescription.fromJson(Map<String, dynamic> map)
      : this(
          sets: int.parse(map[keySets].toString()),
          reps: int.parse(map[keyReps].toString()),
          setRest: int.parse(map[keySetRest].toString()),
          restTime: int.parse(map[keyRestTime].toString()),
          holdTime: int.parse(map[keyHoldTime].toString()),
          targetLoad: double.parse(map[keyTargetLoad].toString()),
          mvcDuration: int.parse(map[keyMvcDuration].toString()),
          isAdmin: map[keyIsAdmin] as bool?,
        );

  @HiveField(0)
  final int sets;
  @HiveField(1)
  final int reps;
  @HiveField(2)
  final int setRest;
  @HiveField(3)
  final int holdTime;
  @HiveField(4)
  final int restTime;
  @HiveField(5)
  final int mvcDuration;
  @HiveField(6)
  final double targetLoad;
  @HiveField(7)
  bool? isAdmin;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      keySets: sets,
      keyReps: reps,
      keySetRest: setRest,
      keyHoldTime: holdTime,
      keyRestTime: restTime,
      keyTargetLoad: targetLoad,
      keyMvcDuration: mvcDuration,
      keyIsAdmin: isAdmin,
    };
  }

  CustomTable toTable() {
    return CustomTable(columns: const <DataColumn>[
      DataColumn(label: Text('Prescription', style: ts18w5)),
      DataColumn(label: Text('Value', style: ts18w5)),
    ], rows: detailRows);
  }

  List<DataRow> get detailRows {
    return <DataRow>[
      DataRow(cells: <DataCell>['Target load'.toCell, '$targetLoad Kg'.toCell]),
      DataRow(cells: <DataCell>['Sets #'.toCell, '$sets'.toCell]),
      DataRow(cells: <DataCell>['Reps #'.toCell, '$reps'.toCell]),
      DataRow(cells: <DataCell>['Hold time'.toCell, '$holdTime Sec'.toCell]),
      DataRow(cells: <DataCell>['Rest time'.toCell, '$restTime Sec'.toCell]),
      DataRow(cells: <DataCell>['Set rest time'.toCell, '$setRest Sec'.toCell]),
    ];
  }
}

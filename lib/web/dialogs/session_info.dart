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
import 'package:tendon_loader/custom/custom_table.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

@immutable
class SessionInfo extends StatelessWidget {
  const SessionInfo({Key? key, required this.export}) : super(key: key);

  final Export export;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      const SizedBox(height: 10),
      CustomTable(columns: const <DataColumn>[
        DataColumn(label: Text('Session', style: ts18w5)),
        DataColumn(label: Text('Detail', style: ts18w5)),
      ], rows: <DataRow>[
        DataRow(cells: <DataCell>[
          'User ID'.toCell,
          (export.userId!).toCell,
        ]),
        DataRow(cells: <DataCell>[
          'Created on'.toCell,
          (export.dateTime).toCell,
        ]),
        DataRow(cells: <DataCell>[
          'Type'.toCell,
          (export.isMVC ? 'MVC Test' : 'Exercise').toCell,
        ]),
        DataRow(cells: <DataCell>[
          'Data status'.toCell,
          (export.status).toCell,
        ]),
        DataRow(cells: <DataCell>[
          'Device'.toCell,
          export.progressorId!.toCell,
        ]),
        DataRow(cells: <DataCell>[
          'Pain score'.toCell,
          '${export.painScore ?? 'Unknown'}'.toCell
        ]),
        DataRow(cells: <DataCell>[
          'Pain tolerable?'.toCell,
          (export.isTolerable ?? 'Unknown').toCell
        ]),
        if (export.isMVC)
          DataRow(cells: <DataCell>[
            'Max force'.toCell,
            '${export.mvcValue} Kg'.toCell
          ]),
        if (!export.isMVC) ...export.prescription!.detailRows,
      ]),
    ]);
  }
}

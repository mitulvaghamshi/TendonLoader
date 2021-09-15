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
import 'package:tendon_loader/custom/app_frame.dart';
import 'package:tendon_loader/custom/data_table_row.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/web/common.dart';

@immutable
class DataList extends StatelessWidget {
  const DataList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: SizedBox(
        width: 300,
        child: ValueListenableBuilder<Export?>(
          valueListenable: exportNotifier,
          builder: (_, Export? export, Widget? child) {
            final List<ChartData>? _list = export?.exportData;
            return Column(children: <Widget>[
              const DataTableRow(
                color: colorAccentBlack,
                left: Text('NO.', style: tsW),
                center: Text('TIME', style: tsW),
                right: Text('LOAD', style: tsW),
              ),
              if (export == null || _list!.isEmpty)
                child!
              else
                Expanded(
                  child: ListView.builder(
                    itemExtent: 50,
                    primary: false,
                    itemCount: _list.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (_, int index) {
                      return DataTableRow(
                        left: Text('${index + 1}.'),
                        center: Text(_list[index].time.toStringAsFixed(1)),
                        right: Text(_list[index].load.toStringAsFixed(2)),
                      );
                    },
                  ),
                ),
            ]);
          },
          child: const SizedBox(),
        ),
      ),
    );
  }
}

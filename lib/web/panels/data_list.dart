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

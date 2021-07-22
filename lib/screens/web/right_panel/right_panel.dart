import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/screens/web/right_panel/data_list.dart';
import 'package:tendon_loader/screens/web/right_panel/data_view.dart';

class RightPanel extends StatelessWidget {
  const RightPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: StreamBuilder<Export>(
        stream: selectedItemStream,
        builder: (_, AsyncSnapshot<Export> snapshot) {
          if (!snapshot.hasData) return const Center(child: AppLogo(radius: 300));
          if (MediaQuery.of(context).size.width > 640) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Expanded(child: DataView(export: snapshot.data!)),
              DataList(export: snapshot.data!),
            ]);
          } else {
            return PageView(children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 50), child: DataView(export: snapshot.data!)),
              Padding(padding: const EdgeInsets.only(top: 50), child: DataList(export: snapshot.data!)),
            ]);
          }
        },
      ),
    );
  }
}

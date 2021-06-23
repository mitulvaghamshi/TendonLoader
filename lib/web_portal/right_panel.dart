import 'package:flutter/material.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/handler/click_handler.dart';
import 'package:tendon_loader/web_portal/data_view.dart';
import 'package:tendon_loader/web_portal/graph.dart';

class RightPanel extends StatefulWidget {
  const RightPanel({Key? key}) : super(key: key);

  @override
  _RightPanelState createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: StreamBuilder<Export>(
        stream: exportItemStream,
        builder: (_, AsyncSnapshot<Export> snapshot) {
          if (!snapshot.hasData) return const Center(child: AppLogo(radius: 300));
          final Export _export = snapshot.data!;
          if (MediaQuery.of(context).size.width > 640) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Expanded(child: Graph(export: _export)),
              DataView(export: _export),
            ]);
          } else {
            return PageView(
              children: <Widget>[
                Container(margin: const EdgeInsets.only(top: 30), child: Graph(export: _export)),
                Container(margin: const EdgeInsets.only(top: 30), child: DataView(export: _export)),
              ],
            );
          }
        },
      ),
    );
  }
}

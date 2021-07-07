import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/web_portal/custom/data_view.dart';
import 'package:tendon_loader/web_portal/custom/graph.dart';
import 'package:tendon_loader/web_portal/handler/click_handler.dart';

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
          if (MediaQuery.of(context).size.width > 640) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Expanded(child: Graph(export: snapshot.data!)),
              DataView(export: snapshot.data!),
            ]);
          } else {
            return PageView(children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 50), child: Graph(export: snapshot.data!)),
              Padding(padding: const EdgeInsets.only(top: 50), child: DataView(export: snapshot.data!)),
            ]);
          }
        },
      ),
    );
  }
}

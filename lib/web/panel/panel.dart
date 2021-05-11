import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/custom/custom_textfield.dart';
import 'package:tendon_loader/shared/validator.dart';

class Panel extends StatefulWidget {
  const Panel({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> with ValidateSearchMixin {
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: Column(children: <Widget>[
        CustomTextField(label: 'Search...', controller: searchCtrl),
        const SizedBox(height: 10),
        widget.child,
      ]),
    );
  }
}

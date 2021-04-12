import 'package:flutter/material.dart';
import 'package:tendon_loader/components/app_frame.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/utils/app/constants.dart';
import 'package:tendon_loader/utils/controller/file_path.dart';
import 'package:tendon_loader/utils/controller/validator.dart';

class Panel extends StatefulWidget {
  const Panel({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> with ValidateSearchMixin, FilePath, Link {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: Column(children: <Widget>[CustomTextField(label: 'Search...', controller: _searchCtrl), const SizedBox(height: 10), widget.child]),
    );
  }
}

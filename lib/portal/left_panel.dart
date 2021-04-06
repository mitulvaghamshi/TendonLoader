import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/components/app_frame.dart';
import 'package:tendon_loader/components/custom_listitem.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/utils/storage.dart';
import 'package:tendon_loader/utils/validator.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({Key key}) : super(key: key);

  @override
  _LeftPanelState createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> with ValidateSearchMixin {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: Column(
        children: <Widget>[
          CustomTextField(label: 'Search...', controller: _searchCtrl),
          const SizedBox(height: 10),
          FutureBuilder<List<Reference>>(
            future: Storage.getUserList(),
            builder: (BuildContext context, AsyncSnapshot<List<Reference>> snapshot) {
              if (snapshot.hasData) return Column(children: snapshot.data.map((Reference user) => CustomListItem(item: user)).toList());
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}

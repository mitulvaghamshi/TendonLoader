import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/components/custom_listitem.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/portal/util.dart';
import 'package:tendon_loader/utils/uploader.dart';
import 'package:tendon_loader/utils/user_path.dart';
import 'package:tendon_loader/utils/validator.dart';

class RightPanel extends StatefulWidget {
  const RightPanel({Key key}) : super(key: key);

  @override
  _RightPanelState createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> with ValidateSearchMixin, UserPath {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            CustomTextField(label: 'Search...', controller: _searchCtrl),
            const SizedBox(height: 10),
            StreamBuilder<String>(
              stream: UserPath.stream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return FutureBuilder<List<Reference>>(
                    future: Uploader.getUserData(snapshot.data),
                    builder: (BuildContext context, AsyncSnapshot<List<Reference>> snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                            children: snapshot.data.map((Reference file) {
                          return CustomListItem(item: file, callback: () async => openLink(await file.getDownloadURL()));
                        }).toList());
                      }
                      return const CircularProgressIndicator();
                    },
                  );
                }
                return const CustomImage(isLogo: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}

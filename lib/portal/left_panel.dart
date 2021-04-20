import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/portal/panel.dart';
import 'package:tendon_loader/utils/app/constants.dart';
import 'package:tendon_loader/utils/controller/file_path.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(Keys.KEY_ALL_USERS).snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> users) {
          if (users.hasData) {
            final List<QueryDocumentSnapshot> _docs = users.data.docs;
            return Expanded(
              child: ListView.separated(
                itemCount: _docs.length,
                separatorBuilder: (_, __) => Divider(color: Theme.of(context).accentColor),
                itemBuilder: (_, int index) {
                  return ListTile(
                    onTap: () async => FilePath.sink?.add(_docs[index].reference),
                    title: Text(_docs[index].id, style: const TextStyle(fontSize: 16)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    subtitle: Text('Last active: ${_docs[index].get(Keys.KEY_LAST_ACTIVE)}', style: const TextStyle(fontSize: 12)),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      foregroundColor: Theme.of(context).primaryColor,
                      child: Text(_docs[index].id[0].toUpperCase()),
                    ),
                  );
                },
              ),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

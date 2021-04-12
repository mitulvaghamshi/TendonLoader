import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/portal/panel.dart';
import 'package:tendon_loader/utils/controller/file_path.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('all-users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> users) {
          if (users.hasData) {
            return Column(
              children: users.data.docs.map((QueryDocumentSnapshot user) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(5),
                  onTap: () async => FilePath.sink?.add(user.reference),
                  title: Text(user.id, style: const TextStyle(fontSize: 16)),
                  leading: CircleAvatar(child: Text(user.id[0].toUpperCase())),
                  subtitle: Text('Last active: ${user.get('lastActive')}', style: const TextStyle(fontSize: 12)),
                );
              }).toList(),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_avater.dart';
import 'package:tendon_loader/web/handler/user_reference.dart';
import 'package:tendon_loader/web/panel/panel.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(Keys.KEY_ALL_USERS).snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Something wants wrong!.');
          }
          return Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: ListTile.divideTiles(
                color: Theme.of(context).accentColor,
                tiles: snapshot.data.docs.map<ListTile>((QueryDocumentSnapshot user) {
                  return ListTile(
                    hoverColor: Colors.blue,
                    key: ValueKey<String>(user.id),
                    contentPadding: const EdgeInsets.all(10),
                    leading: TextAvatar(user.id[0].toUpperCase()),
                    title: Text(user.id, style: const TextStyle(fontSize: 18)),
                    onTap: () => UserReference.sink?.add(user.reference),
                  );
                }),
              ).toList(),
            ),
          );
        },
      ),
    );
  }
}

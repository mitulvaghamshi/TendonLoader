import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/bloc/user_reference.dart';
import 'package:tendon_loader/components/text_avater.dart';
import 'package:tendon_loader/portal/panel.dart';
import 'package:tendon_loader/utils/app/constants.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collectionGroup(Keys.KEY_ALL_USERS).get(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
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
                    onTap: () => UserReference.sink?.add(user.reference.collection(Keys.KEY_ALL_EXPORTS)),
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

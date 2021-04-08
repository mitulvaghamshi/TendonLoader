import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_listitem.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/controller/file_path.dart';

class ListContent extends StatelessWidget with Link {
  const ListContent({Key key, @required this.future, this.isUser = false}) : super(key: key);

  final Future<List<Reference>> Function() future;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Reference>>(
      future: future(),
      builder: (BuildContext context, AsyncSnapshot<List<Reference>> snapshot) {
        if (snapshot.hasData)
          return Column(
              children: snapshot.data.map((Reference item) {
            return CustomListItem(
              item: item,
              callback: isUser ? () async => FilePath.sink?.add(item.fullPath) : () async => goto(await item.getDownloadURL()),
            );
          }).toList());
        return const CircularProgressIndicator();
      },
    );
  }
}

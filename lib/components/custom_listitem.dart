import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/user_path.dart';

class CustomListItem extends StatelessWidget with UserPath {
  const CustomListItem({Key key, this.item, this.callback}) : super(key: key);

  final Reference item;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      confirmDismiss: (DismissDirection directions) => Future<bool>.delayed(const Duration(seconds: 1), () => false),
      child: ListTile(
        title: Text(item.name),
        leading: const Icon(Icons.person),
        subtitle: const Text('Some descriptions.'),
        onTap: callback ?? () async => UserPath.sink?.add(item.fullPath),
      ),
    );
  }
}

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({Key key, this.item, this.callback}) : super(key: key);

  final Reference item;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      confirmDismiss: (DismissDirection directions) => Future<bool>.delayed(const Duration(seconds: 1), () => false),
      child: ListTile(
        onTap: callback,
        title: Text(item.name),
        leading: const Icon(Icons.person),
        subtitle: const Text('Some descriptions.'),
      ),
    );
  }
}

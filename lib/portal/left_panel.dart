import 'package:flutter/material.dart';
import 'package:tendon_loader/portal/list_content.dart';
import 'package:tendon_loader/portal/panel.dart';
import 'package:tendon_loader/utils/app/data_store.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Panel(child: ListContent(future: DataStore.getUserList, isUser: true));
}

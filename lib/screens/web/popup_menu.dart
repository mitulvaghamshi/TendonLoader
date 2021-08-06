import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/utils/themes.dart';

class PopupMenu extends StatelessWidget {
  const PopupMenu({Key? key, required this.onSelected, this.isUser = false}) : super(key: key);

  final bool? isUser;
  final ValueChanged<PopupAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopupAction>(
      onSelected: onSelected,
      icon: Icon(isUser! ? Icons.settings : Icons.more_vert),
      itemBuilder: (_) => <PopupMenuItem<PopupAction>>[
        if (isUser!) ...<PopupMenuItem<PopupAction>>[
          const PopupMenuItem<PopupAction>(
            value: PopupAction.history,
            child: ListTile(title: Text('History'), leading: Icon(Icons.history)),
          ),
          const PopupMenuItem<PopupAction>(
            value: PopupAction.prescribe,
            child: ListTile(title: Text('Prescriptions'), leading: Icon(Icons.edit)),
          ),
        ],
        const PopupMenuItem<PopupAction>(
          value: PopupAction.download,
          child: ListTile(title: Text('Download'), leading: Icon(Icons.file_download)),
        ),
        const PopupMenuItem<PopupAction>(
          value: PopupAction.delete,
          child: ListTile(
            leading: Icon(Icons.delete_forever, color: colorRed400),
            title: Text('Delete', style: TextStyle(color: colorRed400)),
          ),
        ),
      ],
    );
  }
}

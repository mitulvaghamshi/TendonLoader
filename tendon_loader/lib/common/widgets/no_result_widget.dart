import 'package:flutter/material.dart';

class NoResultWidget extends StatelessWidget {
  const NoResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Icon(Icons.hourglass_empty),
        SizedBox(width: 5),
        Text('Nothing to show here...'),
      ]),
    );
  }
}

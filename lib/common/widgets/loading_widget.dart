import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        CircularProgressIndicator.adaptive(),
        SizedBox(width: 5),
        Text('Please wait...'),
      ]),
    );
  }
}

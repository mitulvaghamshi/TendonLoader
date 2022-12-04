import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(mainAxisSize: MainAxisSize.min, children: const <Widget>[
        CircularProgressIndicator.adaptive(),
        SizedBox(width: 5),
        Text('Please wait...'),
      ]),
    );
  }
}

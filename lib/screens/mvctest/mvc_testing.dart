import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/screens/mvctest/mvc_handler.dart';
import 'package:tendon_loader/utils/themes.dart';

class MVCTesting extends StatelessWidget {
  const MVCTesting({Key? key}) : super(key: key);

  static const String name = 'MVC Testing';
  static const String route = '/mvcTesting';

  @override
  Widget build(BuildContext context) {
    final MVCHandler _handler = MVCHandler(context: context);
    return CustomGraph(
      title: name,
      handler: _handler,
      builder: () => Column(children: <Widget>[
        Text(_handler.maxForceValue, style: tsG40B),
        Text(_handler.timeDiffValue, style: tsR40B),
      ]),
    );
  }
}

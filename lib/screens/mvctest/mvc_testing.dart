import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/screens/mvctest/mvc_handler.dart';
import 'package:tendon_loader/utils/themes.dart';

class MVCTesting extends StatefulWidget {
  const MVCTesting({Key? key}) : super(key: key);

  static const String name = 'MVC Testing';
  static const String route = '/mvcTesting';

  @override
  _MVCTestingState createState() => _MVCTestingState();
}

class _MVCTestingState extends State<MVCTesting> {
  late final MVCHandler _handler = MVCHandler(context: context);

  @override
  Widget build(BuildContext context) {
    return CustomGraph(
      handler: _handler,
      title: MVCTesting.name,
      builder: () => Column(children: <Widget>[
        Text(_handler.maxForceValue, style: tsG40B),
        Text(_handler.timeDiffValue, style: tsR40B),
      ]),
    );
  }
}

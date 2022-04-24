import 'package:flutter/material.dart';
import 'package:tendon_loader/app/graph/graph_widget.dart';
import 'package:tendon_loader/app/mvctest/mvc_handler.dart';

class MVCTesting extends StatefulWidget {
  const MVCTesting({Key? key}) : super(key: key);

  static const String name = 'MVC Testing';
  static const String route = '/mvctesting';

  @override
  _MVCTestingState createState() => _MVCTestingState();
}

class _MVCTestingState extends State<MVCTesting> {
  late final MVCHandler _handler = MVCHandler(context: context);

  @override
  Widget build(BuildContext context) {
    return GraphWidget(
      handler: _handler,
      title: MVCTesting.name,
      builder: () => Column(children: <Widget>[
        Text(
          _handler.maxForceValue,
          style: const TextStyle(
            fontSize: 40,
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          _handler.timeDiffValue,
          style: const TextStyle(
            fontSize: 40,
            color: Color(0xffff534d),
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
    );
  }
}

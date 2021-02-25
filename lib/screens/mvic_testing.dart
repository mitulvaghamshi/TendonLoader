import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/bar_graph.dart';

class MVICTesting extends StatefulWidget {
  static const name = 'MVIC Testing';
  static const routeName = '/mvicTesting';

  MVICTesting({Key key}) : super(key: key);

  @override
  _MVICTestingState createState() => _MVICTestingState();
}

class _MVICTestingState extends State<MVICTesting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MVICTesting.name)),
      body: const BarGraph(isMVICTesting: true),
    );
  }
}

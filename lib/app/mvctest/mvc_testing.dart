import 'package:flutter/material.dart';
import 'package:tendon_loader/app/mvctest/bar_graph.dart';

class MVCTesting extends StatelessWidget {
  const MVCTesting({Key? key}) : super(key: key);

  static const String name = 'MVC Testing';
  static const String route = '/mvcTesting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text(MVCTesting.name)), body: const BarGraph());
  }
}

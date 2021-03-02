import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/mvc_testing/bar_graph.dart';

class MVCTesting extends StatelessWidget {
  static const name = 'MVC Testing';
  static const routeName = '/mvcTesting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MVCTesting.name)),
      body: const BarGraph(),
    );
  }
}

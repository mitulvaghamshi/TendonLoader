import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/mvc_testing/bar_graph.dart';
import 'package:tendon_loader/utils/controller/create_excel.dart';

class MVCTesting extends StatelessWidget with CreateExcel {
  const MVCTesting({Key key}) : super(key: key);

  static const String name = 'MVC Testing';
  static const String route = '/mvcTesting';

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text(MVCTesting.name)), body: const BarGraph());
}

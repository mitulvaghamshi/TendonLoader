import 'package:flutter/material.dart';
import 'package:tendon_loader/components/export_button.dart';
import 'package:tendon_loader/screens/mvc_testing/bar_graph.dart';
import 'package:tendon_loader/utils/create_xlsx.dart';

class MVCTesting extends StatelessWidget with CreateXLSX {
  const MVCTesting({Key key}) : super(key: key);

  static const String name = 'MVC Testing';
  static const String routeName = '/mvcTesting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const BarGraph(),
      appBar: AppBar(
        title: const Text(MVCTesting.name),
        actions: <ExportButton>[ExportButton(callback: export)],
      ),
    );
  }
}

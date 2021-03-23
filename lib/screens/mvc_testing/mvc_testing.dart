import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/screens/mvc_testing/bar_graph.dart';
import 'package:tendon_loader/utils/create_xlsx.dart';

class MVCTesting extends StatelessWidget with CreateXLSX {
  static const name = 'MVC Testing';
  static const routeName = '/mvcTesting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const BarGraph(),
      appBar: AppBar(
        title: const Text(MVCTesting.name),
        actions: [CustomButton(text: 'Export Data', icon: Icons.backup_rounded, onPressed: export)],
      ),
    );
  }
}

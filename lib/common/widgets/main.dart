import 'package:flutter/material.dart';
import 'package:tendon_loader/common/widgets/loading_widget.dart';
import 'package:tendon_loader/common/widgets/no_result_widget.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    darkTheme: ThemeData.dark(useMaterial3: true),
    home: Scaffold(
      appBar: AppBar(title: const Text('Test App')),
      body: Column(children: const <Widget>[
        LoadingWidget(),
        NoResultWidget(),
      ]),
    ),
  ));
}

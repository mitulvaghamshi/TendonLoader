import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tendon_loader/components/app_frame.dart';
import 'package:tendon_loader/components/countdown.dart';
import 'package:tendon_loader/components/custom_graph.dart';
import 'package:tendon_loader/components/graph_controls.dart';
import 'package:tendon_loader/utils/data_handler.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key/*?*/ key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  final DataHandler _handler = DataHandler();
  bool _isRunning = false;

  Future<void> _reset() async {
    _isRunning = false;
    await _handler.reset();
  }

  Future<void> _start() async {
    if (!_isRunning && (await CountDown.start(context) ?? false)) {
      _isRunning = true;
      await _handler.start();
    }
  }

  @override
  void dispose() {
    _handler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Card(
      elevation: 16,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            StreamBuilder<int>(
              initialData: 0,
              stream: _handler.timeStream,
              builder: (_, AsyncSnapshot<int> snapshot) => Text(
                'Time elapsed: ${snapshot.data/*!*/ ~/ 60}:${(snapshot.data/*!*/ % 60).toString().padLeft(2, '0')} s',
                style: const TextStyle(fontSize: 26, color: Colors.green, fontWeight: FontWeight.bold),
              ),
=======
    return AppFrame(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<int>(
            initialData: 0,
            stream: _handler.timeStream,
            builder: (_, AsyncSnapshot<int> snapshot) => Text(
              'Time elapsed: ${snapshot.data ~/ 60}:${(snapshot.data % 60).toString().padLeft(2, '0')} s',
              style: const TextStyle(fontSize: 26, color: Colors.green, fontWeight: FontWeight.bold),
>>>>>>> Stashed changes
            ),
          ),
          const SizedBox(height: 20),
          CustomGraph(isLive: true, series: _handler.getSeries),
          const SizedBox(height: 30),
          GraphControls(start: _start, reset: _reset),
        ],
      ),
    );
  }
}

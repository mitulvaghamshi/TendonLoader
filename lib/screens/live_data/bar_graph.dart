import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/components/countdown.dart';
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
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                series: _handler.getSeries(),
                primaryXAxis: CategoryAxis(minimum: 0, maximum: 0, isVisible: false),
                primaryYAxis: NumericAxis(
                  maximum: 30,
                  labelFormat: '{value} kg',
                  axisLine: AxisLine(width: 0),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <FloatingActionButton>[
                FloatingActionButton(
                  onPressed: _start,
                  heroTag: 'start-btn',
                  child: const Icon(Icons.play_arrow_rounded),
                ),
                FloatingActionButton(
                  onPressed: _reset,
                  heroTag: 'reset-btn',
                  child: const Icon(Icons.replay_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

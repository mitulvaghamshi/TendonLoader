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
  final DataHandler _handler = DataHandler(targetLoad: 0, isMVC: true);
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
          children: <Widget>[
            StreamBuilder<double>(
              initialData: 0,
              stream: _handler.weightStream,
              builder: (_, AsyncSnapshot<double> snapshot) {
                return Text(
                  'MVC: ${snapshot.data/*!*/.toStringAsFixed(2).padLeft(2, '0')} Kg',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<int>(
              initialData: 0,
              stream: _handler.timeStream,
              builder: (_, AsyncSnapshot<int> snapshot) {
                if (5 - snapshot.data/*!*/ == 0) _handler.stop();
                return Text(
                  'Remaining time: ${5 - snapshot.data/*!*/} s',
                  style: const TextStyle(fontSize: 26, color: Colors.deepOrange, fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                series: _handler.getSeries(),
                primaryXAxis: NumericAxis(minimum: 0, isVisible: false),
                primaryYAxis: NumericAxis(
                  maximum: 30,
                  labelFormat: '{value} kg',
                  axisLine: AxisLine(width: 0),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <FloatingActionButton>[
                FloatingActionButton(onPressed: _start, heroTag: 'start-btn', child: const Icon(Icons.play_arrow_rounded)),
                FloatingActionButton(onPressed: _reset, heroTag: 'reset-btn', child: const Icon(Icons.replay_rounded)),
              ],
            ),
          ],
        ),
=======
    return AppFrame(
      child: Column(
        children: <Widget>[
          StreamBuilder<double>(
            initialData: 0,
            stream: _handler.weightStream,
            builder: (_, AsyncSnapshot<double> snapshot) {
              return Text(
                'MVC: ${snapshot.data.toStringAsFixed(2).padLeft(2, '0')} Kg',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              );
            },
          ),
          const SizedBox(height: 20),
          StreamBuilder<int>(
            initialData: 0,
            stream: _handler.timeStream,
            builder: (_, AsyncSnapshot<int> snapshot) {
              if (5 - snapshot.data == 0) _handler.stop();
              return Text(
                'Remaining time: ${5 - snapshot.data} s',
                style: const TextStyle(fontSize: 26, color: Colors.deepOrange, fontWeight: FontWeight.bold),
              );
            },
          ),
          const SizedBox(height: 20),
          CustomGraph(series: _handler.getSeries),
          const SizedBox(height: 30),
          GraphControls(start: _start, reset: _reset),
        ],
>>>>>>> Stashed changes
      ),
    );
  }
}

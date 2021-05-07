import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:tendon_loader/app/custom/countdown.dart';
import 'package:tendon_loader/app/custom/custom_controls.dart';
import 'package:tendon_loader/app/custom/custom_graph.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/app/handler/data_handler.dart';
import 'package:tendon_loader/shared/common.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/extensions.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  final DataHandler _handler = DataHandler();
  bool _isRunning = false;

  SendPort sendPort;

  Future<void> _start() async {
    if (!_isRunning /* && (await CountDown.start(context) ?? false) */) {
      await _handler.start();
      await Bluetooth.startWeightMeas();
      _isRunning = true;
      sendPort = await _handler.completer.future;
      Future<void>.delayed(const Duration(seconds: 2), () {
        Bluetooth.listen(sendPort.send);
      });
    }
  }

  Future<void> _reset() async {
    if (_isRunning) {
      _isRunning = false;
      await _handler.reset();
      CustomGraph.updateGraph(ChartData());
    }
  }

  @override
  void dispose() {
    _reset();
    _handler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<dynamic>(
            initialData: ChartData(),
            stream: _handler.stream,
            builder: (_, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data is SendPort) {
                _handler.completer.complete(snapshot.data as SendPort);
                return Text('data');
              }
              final ChartData data = snapshot.data as ChartData;
              CustomGraph.updateGraph(data);
              return Text(data.time.formatTime, style: tsBold26.copyWith(color: Colors.green));
            },
          ),
          const SizedBox(height: 20),
          const CustomGraph(),
          const SizedBox(height: 30),
          GraphControls(start: _start, reset: _reset),
        ],
      ),
    );
  }
}

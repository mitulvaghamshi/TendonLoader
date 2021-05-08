import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
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

  Future<void> _start() async {
    if (!_isRunning /* && (await CountDown.start(context) ?? false) */) {
      _isRunning = true;
      await _handler.start();
    }
  }

  Future<void> _reset() async {
    if (_isRunning) {
      _isRunning = false;
      await _handler.reset();
    }
    mData.forEach(print);
  }

  @override
  void dispose() {
    _reset();
    _handler.dispose();
    super.dispose();
  }

  final List<ChartData> mData = <ChartData>[];

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
                _handler.listen(snapshot.data);
                return const CircularProgressIndicator();
              }
              final ChartData _data = snapshot.data as ChartData;
              mData.add(_data);
              CustomGraph.updateGraph(_data);
              return Text(_data.time.formatTime, style: tsBold26.copyWith(color: Colors.green));
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

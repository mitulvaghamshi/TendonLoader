import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/custom/custom_controls.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/exercise/progress_handler.dart';
import 'package:tendon_loader/handler/device_handler.dart';
import 'package:tendon_loader/handler/dialog_handler.dart';
import 'package:tendon_loader/handler/graph_data_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/utils/clip_player.dart';
import 'package:tendon_loader/utils/themes.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> with WidgetsBindingObserver {
  final List<ChartData> _graphData = <ChartData>[];
  ChartSeriesController? _graphCtrl;
  late final ProgressHandler _handler;
  late final Prescription _pre;
  late Timestamp? _timestamp;
  bool _hasData = false;
  int _minSec = 0;

  // late Timer? _exitTimer;
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused && isDeviceRunning) {
  //     print('running in background');
  //     _exitTimer = Timer(const Duration(seconds: 15), () async {
  //       print('elapsed: ${_exitTimer!.tick}');
  //       print('time out!, stop and save data.');
  //       await Navigator.maybePop(context);
  //     });
  //   }
  //   if (state == AppLifecycleState.resumed) {
  //     print('resumed...');
  //     if (_exitTimer?.isActive ?? false) {
  //       print('timer canceled...');
  //       _exitTimer?.cancel();
  //     }
  //   }
  // }

  Future<void> _onStart() async {
    if (_handler.isSetOver && _handler.isRunning) {
      _handler.isSetOver = false;
    } else if (!_handler.isRunning && _hasData) {
      await _onExit();
    } else if (await startCountdown(context) ?? false) {
      _timestamp = Timestamp.now();
      _handler.isComplete = false;
      _handler.isRunning = true;
      _hasData = true;
      play(true);
      exportDataList.clear();
      await startWeightMeas();
    }
  }

  Future<void> _onReset() async {
    if (_handler.isRunning) {
      _handler.isRunning = false;
      _minSec = 0;
      play(false);
      await stopWeightMeas();
      if (_handler.isComplete) {
        await congratulate(context);
        await _onExit();
      }
    }
  }

  Future<void> _onSetOver() async {
    await Future<void>.microtask(() async {
      final bool? result = await startCountdown(
        context,
        title: 'Set Over, Rest!!!',
        duration: Duration(seconds: _pre.setRest),
      );
      if (result ?? false) await _onStart();
    });
  }

  void _onStop() => _handler.isSetOver = true;

  Future<bool> _onExit() async {
    if (!_hasData) return true;
    final Export _export = Export(
      prescription: _pre,
      timestamp: _timestamp!,
      progressorId: deviceName,
      exportData: exportDataList,
      isComplate: _handler.isComplete,
      userId: context.model.currentUser!.id,
    );
    if (_handler.isRunning) {
      await stopWeightMeas();
      return submitData(context, _export, false);
    }
    final bool? result;
    if (context.model.settingsState!.autoUpload!) {
      result = await submitData(context, _export, false);
    } else {
      result = await confirmSubmit(context, _export);
    }
    if (result == null) {
      return false;
    } else {
      _hasData = false;
    }
    return result;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance!.addObserver(this);
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pre = context.model.prescription!;
    _handler = ProgressHandler(pre: _pre, onReset: _onReset, onSetOver: _onSetOver);
  }

  @override
  void dispose() {
    _onReset();
    // WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onExit: _onExit,
      child: Column(children: <Widget>[
        StreamBuilder<ChartData>(
          stream: graphDataStream,
          initialData: ChartData(),
          builder: (_, AsyncSnapshot<ChartData> snapshot) {
            _graphData.insert(0, snapshot.data!);
            _graphCtrl?.updateDataSource(updatedDataIndex: 0);
            if (!_handler.isSetOver && snapshot.data!.time!.truncate() > _minSec) {
              _minSec = snapshot.data!.time!.truncate();
              _handler.update();
            }
            return FittedBox(
              fit: BoxFit.fitWidth,
              child: Column(children: <Widget>[
                Text(
                  _handler.lapTime,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: _handler.isHold ? colorGoogleGreen : colorRed400,
                  ),
                ),
                const SizedBox(height: 10),
                Chip(
                  padding: const EdgeInsets.all(16),
                  label: Text(
                    _handler.progress,
                    style: const TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: snapshot.data!.load! > _pre.targetLoad ? colorGoogleGreen : colorGoogleYellow,
                ),
              ]),
            );
          },
        ),
        CustomGraph(
          graphData: _graphData,
          graphCtrl: (ChartSeriesController ctrl) => _graphCtrl = ctrl,
          lineData: <ChartData>[ChartData(load: _pre.targetLoad), ChartData(time: 2, load: _pre.targetLoad)],
        ),
        GraphControls(start: _onStart, stop: _onStop, reset: _onReset),
      ]),
    );
  }
}

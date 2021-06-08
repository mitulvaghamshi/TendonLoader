import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/custom/confirm_dialod.dart';
import 'package:tendon_loader/custom/countdown.dart';
import 'package:tendon_loader/custom/custom_controls.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader/handler/clip_player.dart';
import 'package:tendon_loader/handler/data_handler.dart';
import 'package:tendon_loader/handler/export_handler.dart';
import 'package:tendon_loader/exercise/progress_handler.dart';
import 'package:tendon_loader/settings/settings_model.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key, required this.prescription}) : super(key: key);

  final Prescription prescription;

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> with WidgetsBindingObserver {
  late final ProgressHandler _handler = ProgressHandler(
    onReset: _reset,
    onSetOver: _setOver,
    pre: widget.prescription,
  );
  final List<ChartData> _graphData = <ChartData>[];
  ChartSeriesController? _graphCtrl;
  late DateTime _dateTime;
  bool _hasData = false;
  int _minSec = 0;

  late Timer? _exitTimer;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && isDeviceRunning) {
      print('running in background');
      _exitTimer = Timer(const Duration(seconds: 15), () async {
        print('elapsed: ${_exitTimer!.tick}');
        print('time out!, stop and save data.');
        await Navigator.maybePop(context);
      });
    }
    if (state == AppLifecycleState.resumed) {
      print('resumed...');
      if (_exitTimer?.isActive ?? false) {
        print('timer canceled...');
        _exitTimer?.cancel();
      }
    }
  }

  Future<void> _start() async {
    if (_handler.isSetOver && _handler.isRunning) {
      _handler.isSetOver = false;
    } else if (!_handler.isRunning && _hasData) {
      await _onExit();
    } else if (await CountDown.start(context) ?? false) {
      await startWeightMeasuring();
      exportDataList.clear();
      _handler.isRunning = true;
      _handler.isComplete = false;
      _dateTime = DateTime.now();
      _hasData = true;
      play(Clip.start);
    }
  }

  Future<void> _reset() async {
    if (_handler.isRunning) {
      _handler.isRunning = false;
      await stopWeightMeasuring();
      play(Clip.stop);
      _minSec = 0;
      if (_handler.isComplete) await _congrats();
    }
  }

  Future<void> _setOver() async {
    // final bool? result = await CountDown.start(
    //   context,
    //   title: 'Set Over, Rest!!!',
    //   duration: Duration(seconds: widget.prescription.setRestTime!),
    // );
    // if (result ?? false) await _start();
    await Future<void>.microtask(() async {
      final bool? result = await CountDown.start(
        context,
        title: 'Set Over, Rest!!!',
        duration: Duration(seconds: widget.prescription.setRestTime!),
      );
      if (result ?? false) await _start();
    });
  }

  void _stop() => _handler.isSetOver = true;

  Future<bool> _onExit() async {
    if (!_hasData) return true;
    print('on exit...');
    late final bool? result;
    final DataModel _dataModel = DataModel(
      dataList: exportDataList,
      prescription: widget.prescription,
      sessionInfo: SessionInfo(
        dateTime: _dateTime,
        progressorId: deviceName,
        dataStatus: _handler.isComplete,
        exportType: keyPrefixExcercise,
        userId: SettingsModel.userId,
      ),
    );
    if (_handler.isRunning) {
      print('running... stop and upload....');
      await stopWeightMeasuring();
      return export(_dataModel, false);
    }
    print('later stuff...');
    if (SettingsModel.autoUpload!) {
      print('auto upload');
      result = await export(_dataModel, false);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Data stored successfully...'),
        ));
      }
    } else {
      result = await ConfirmDialog.show(context, model: _dataModel);
    }
    if (result == null) {
      return false;
    } else {
      _hasData = false;
    }
    return result;
  }

  Future<void> _congrats() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const <Widget>[
              Icon(Icons.emoji_events_rounded, size: 50, color: Colors.green),
              Text('Congratulations!!!', textAlign: TextAlign.center, style: TextStyle(fontSize: 26)),
            ]),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: const Text(
            'Exercise session completed!\nGreat work!',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton.icon(
              label: const Text('Next'),
              icon: const Icon(Icons.arrow_forward),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        );
      },
    );
    await _onExit();
  }

  @override
  void dispose() {
    _reset();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onExit: _onExit,
      child: Column(
        children: <Widget>[
          StreamBuilder<ChartData>(
            stream: graphDataStream,
            initialData: const ChartData(),
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              _graphData.insert(0, snapshot.data!);
              _graphCtrl?.updateDataSource(updatedDataIndex: 0);
              if (!_handler.isSetOver && snapshot.data!.time!.truncate() > _minSec) {
                _minSec = snapshot.data!.time!.truncate();
                _handler.update();
              }
              return FittedBox(
                fit: BoxFit.fitWidth,
                child: Column(
                  children: <Widget>[
                    Text(
                      _handler.lapTime,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: _handler.isHold ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Chip(
                      padding: const EdgeInsets.all(16),
                      label: Text(
                        _handler.progress,
                        style: const TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: snapshot.data!.load! > widget.prescription.targetLoad!
                          ? const Color.fromRGBO(61, 220, 132, 1)
                          : const Color.fromRGBO(239, 247, 207, 1),
                    ),
                  ],
                ),
              );
            },
          ),
          CustomGraph(
            graphData: _graphData,
            graphCtrl: (ChartSeriesController ctrl) => _graphCtrl = ctrl,
            lineData: <ChartData>[
              ChartData(load: widget.prescription.targetLoad),
              ChartData(time: 2, load: widget.prescription.targetLoad),
            ],
          ),
          GraphControls(start: _start, stop: _stop, reset: _reset),
        ],
      ),
    );
  }
}

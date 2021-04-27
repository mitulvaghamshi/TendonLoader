import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/app/custom/countdown.dart';
import 'package:tendon_loader/app/custom/custom_controls.dart';
import 'package:tendon_loader/app/custom/custom_graph.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/shared/common.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/web/create_excel.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> with CreateExcel {
  final DataHandler _handler = DataHandler();
  bool _isRunning = false;

  String _fromSecs(int secs) => 'Time elapsed: ${secs ~/ 60}:${(secs % 60).toString().padLeft(2, '0')} s';

  Future<void> _start() async {
    if (!_isRunning && (await CountDown.start(context) ?? false)) {
      _isRunning = true;
      await _handler.start();
    }
  }

  Future<void> _reset() async {
    if (_isRunning) {
      _isRunning = false;
      await _handler.reset();
    }
    await create(data: _handler.dataList);
  }

  @override
  void dispose() {
    _handler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<int>(
            initialData: 0,
            stream: _handler.timeStream,
            builder: (_, AsyncSnapshot<int> snapshot) {
              return Text(_fromSecs(snapshot.data), style: textStyleBold26.copyWith(color: Colors.green));
            },
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

class DataHandler {
  DataHandler() {
    Bluetooth.listen(_listener);
  }

  Timer _timer;
  ChartSeriesController _graphDataCtrl;
  final List<ChartData> dataList = <ChartData>[];
  final List<ChartData> _graphData = <ChartData>[ChartData()];
  final StreamController<int> _timeCtrl = StreamController<int>();
  final StreamController<double> _weightCtrl = StreamController<double>();

  Stream<int> get timeStream => _timeCtrl.stream;

  Stream<double> get weightStream => _weightCtrl.stream;

  Future<void> start() async {
    if (_timer == null) {
      await Bluetooth.startWeightMeas();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _timeCtrl.sink.add(_timer.tick));
    }
  }

  Future<void> stop() async {
    if (_timer != null) {
      await Bluetooth.stopWeightMeas();
      _timer.cancel();
      _timer = null;
    }
  }

  Future<void> reset() async {
    await stop();
    _timeCtrl.sink.add(0);
    _weightCtrl.sink.add(0);
    _graphData.insert(0, ChartData());
    _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
  }

  Future<void> dispose() async {
    await stop();
    if (!_timeCtrl.isClosed) await _timeCtrl.close();
    if (!_weightCtrl.isClosed) await _weightCtrl.close();
  }

  double lastTime = 0;

  void _listener(List<int> _data) {
    int _counter = 0;
    double _avgTime = 0;
    double _avgWeight = 0;
    double _timeSum = 0;
    double _weightSum = 0;

    double w;
    int t;

    if (_data.isNotEmpty && _data[0] == Progressor.RES_WEIGHT_MEAS) {
      for (int x = 2; x < _data.length; x += 8) {
        _weightSum += w = Uint8List.fromList(_data.getRange(x, x + 4).toList()).buffer.asByteData().getFloat32(0, Endian.little);
        /*_timeSum +=*/
        t = Uint8List.fromList(_data.getRange(x + 4, x + 8).toList()).buffer.asByteData().getUint32(0, Endian.little);
        final double www = double.parse((w.abs()).toStringAsFixed(2));
        final double ttt = double.parse((t / 1000000.0).toStringAsFixed(1));
        if (ttt > lastTime) {
          lastTime = ttt;
          dataList.add(ChartData(load: www, time: ttt));
          _graphData.insert(0, ChartData(load: www));
          _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
        }
      }
    } else if (_data.isNotEmpty && _data[0] == Progressor.RES_LOW_PWR_WARNING) {
      print('Battery Low!');
    }
  }

  List<ChartSeries<ChartData, int>> getSeries() {
    return <ChartSeries<ChartData, int>>[
      ColumnSeries<ChartData, int>(
        width: 0.9,
        borderWidth: 1,
        color: Colors.blue,
        animationDuration: 0,
        dataSource: _graphData,
        borderColor: Colors.black,
        xValueMapper: (ChartData data, _) => 1,
        yValueMapper: (ChartData data, _) => data.load,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          showZeroValue: false,
          labelAlignment: ChartDataLabelAlignment.bottom,
          textStyle: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
        ),
        onRendererCreated: (ChartSeriesController controller) => _graphDataCtrl = controller,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
    ];
  }
}

import 'package:tendon_loader/libs.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key, @required this.prescription}) : super(key: key);

  final Prescription prescription;

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  final List<ChartData> _graphData = <ChartData>[];
  final List<ChartData> _dataList = <ChartData>[];
  final DataHandler _handler = DataHandler();
  ChartSeriesController _graphCtrl;
  List<ChartData> _lineData;
  double _minTime = 0;
  double _minSec = 0;
  double _targetLoad = 0;
  bool _isComplete = false;
  bool _isRunning = false;
  bool _hasData = false;
  bool _isRest = false;
  bool _isHold = true;
  int _currentSet = 1;
  int _currentRep = 1;
  int _holdTime = 0;
  int _restTime = 0;
  DateTime _dateTime;

  String get _lapTime => _isRunning && !_isRest
      ? _isHold
          ? 'Hold for: ${_holdTime--} s'
          : 'Rest for: ${_restTime--} s'
      : '...';

  String get _progress =>
      'Set: $_currentSet of ${widget.prescription.sets}  |  Rep: $_currentRep of ${widget.prescription.reps}';

  Future<void> _start() async {
    if (_isRest && _isRunning) {
      _isRest = false;
    } else if (!_isRunning && _hasData) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Submit old data?'),
        action: SnackBarAction(label: 'Show Me!', onPressed: _handleExport, textColor: Theme.of(context).primaryColor),
      ));
    } else if (await CountDown.start(context) ?? false) {
      await Bluetooth.startWeightMeas();
      _dateTime = DateTime.now();
      _isComplete = false;
      _isRunning = true;
      _hasData = true;
    }
  }

  Future<void> _reset() async {
    if (_isRunning) {
      _isRunning = false;
      await Bluetooth.stopWeightMeas();
      _handler.sink.add(ChartData());
      _holdTime = widget.prescription.holdTime;
      _restTime = widget.prescription.restTime;
      _currentRep = _currentSet = 1;
      _isHold = true;
      _isRest = false;
      _minTime = 0;
      _graphData.insert(0, ChartData());
      _graphCtrl.updateDataSource(updatedDataIndex: 0);
    }
  }

  Future<void> _rest() async {
    Future<void>.delayed(Duration.zero, () async {
      if (await CountDown.start(context, duration: const Duration(seconds: 5), title: 'SET OVER!\nREST!') ?? false)
        await _start();
    });
  }

  void stop() => _isRest = true;

  void _update() {
    if (_holdTime == 0) {
      _isHold = false;
      _holdTime = widget.prescription.holdTime;
    }
    if (_restTime == 0) {
      _isHold = true;
      _restTime = widget.prescription.restTime;
      if (_currentRep == widget.prescription.reps) {
        if (_currentSet == widget.prescription.sets) {
          _isComplete = true;
          _reset();
        } else {
          _currentSet++;
          _currentRep = 1;
          _isRest = true;
          _rest();
        }
      } else {
        _currentRep++;
      }
    }
  }

  Future<bool> _handleExport() async {
    if (_isRunning) await _reset();
    if (!_hasData) return true;
    final bool result = await ConfirmDialog.export(
      context,
      prescription: widget.prescription,
      sessionInfo: SessionInfo(
        dateTime: _dateTime,
        dataStatus: _isComplete,
        exportType: Keys.KEY_PREFIX_EXERCISE,
        userId: (await Hive.openBox<Object>(Keys.KEY_LOGIN_BOX)).get(Keys.KEY_USERNAME) as String,
      ),
    );
    if (result == null) {
      return false;
    } else {
      _hasData = false;
    }
    return result;
  }

  void _listener(List<int> data) {
    if (_isRunning && data.isNotEmpty && data[0] == Progressor.RES_WEIGHT_MEAS) {
      for (int x = 2; x < data.length; x += 8) {
        final double weight = data.getRange(x, x + 4).toList().toWeight;
        final double time = data.getRange(x + 4, x + 8).toList().toTime;
        if (time > _minTime) {
          _minTime = time;
          final ChartData element = ChartData(load: weight, time: time);
          _dataList.add(element);
          if (time.truncate() > _minSec) {
            _minSec = time;
            _handler.sink.add(element);
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Bluetooth.listen(_listener);
    _targetLoad = widget.prescription.targetLoad;
    _holdTime = widget.prescription.holdTime;
    _restTime = widget.prescription.restTime;
    _lineData = <ChartData>[ChartData(load: _targetLoad), ChartData(time: 2, load: _targetLoad)];
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
      onExit: _handleExport,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<ChartData>(
            initialData: ChartData(),
            stream: _handler.stream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              _graphData.insert(0, snapshot.data);
              _graphCtrl?.updateDataSource(updatedDataIndex: 0);
              if (!_isRest && _isRunning) _update();
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(snapshot.data.time.toTime, style: tsBold28.copyWith(color: Colors.green)),
                      Text(_lapTime, style: tsBold28.copyWith(color: Colors.red)),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(_progress, style: tsBold28.copyWith(color: Colors.black, letterSpacing: -1)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: snapshot.data.load >= _targetLoad ? Colors.green : Colors.yellow[200],
                    ),
                  ),
                ],
              );
            },
          ),
          CustomGraph(
            lineData: _lineData,
            graphData: _graphData,
            graphCtrl: (ChartSeriesController ctrl) => _graphCtrl = ctrl,
          ),
          const SizedBox(height: 30),
          GraphControls(start: _start, stop: stop, reset: _reset),
        ],
      ),
    );
  }
}

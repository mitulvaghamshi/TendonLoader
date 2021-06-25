import 'package:rxdart/subjects.dart';
import 'package:tendon_loader/modal/chartdata.dart';

final BehaviorSubject<ChartData> _controller = BehaviorSubject<ChartData>.seeded(ChartData());

Stream<ChartData> get graphDataStream => _controller.stream;

Sink<ChartData> get graphDataSink => _controller.sink;

void clearGraphData() => graphDataSink.add(ChartData());

void disposeGraphData() {
  if (!_controller.isClosed) _controller.close();
}

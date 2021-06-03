import 'package:rxdart/subjects.dart' show BehaviorSubject;
import 'package:tendon_support_lib/tendon_support_lib.dart' show ChartData;

final BehaviorSubject<ChartData> _controller = BehaviorSubject<ChartData>.seeded(const ChartData());

Stream<ChartData> get graphDataStream => _controller.stream;

Sink<ChartData> get graphDataSink => _controller.sink;

void clearGraphData() => graphDataSink.add(const ChartData());

void disposeGraphData() {
  if (!_controller.isClosed) _controller.close();
}

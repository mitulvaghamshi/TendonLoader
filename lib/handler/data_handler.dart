import 'package:rxdart/subjects.dart' show BehaviorSubject;
import 'package:tendon_support_module/modal/chartdata.dart';

mixin DataHandler {
  static final BehaviorSubject<ChartData> _controller = BehaviorSubject<ChartData>.seeded(const ChartData());

  Stream<ChartData> get dataStream => _controller.stream;

  static Sink<ChartData> get dataSink => _controller.sink;

  static void dataClear() => dataSink.add(const ChartData());

  static void dataDispose() {
    if (!_controller.isClosed) _controller.close();
  }
}

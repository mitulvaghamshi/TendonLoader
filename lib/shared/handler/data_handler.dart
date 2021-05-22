import 'package:rxdart/subjects.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';

mixin DataHandler {
  final BehaviorSubject<ChartData> _controller = BehaviorSubject<ChartData>.seeded(const ChartData());

  Stream<ChartData> get dataStream => _controller.stream;

  Sink<ChartData> get dataSink => _controller.sink;

  void dataClear() => dataSink.add(const ChartData());

  void dataDispose() {
    if (!_controller.isClosed) _controller.close();
  }
}

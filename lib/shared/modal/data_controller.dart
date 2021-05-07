import 'package:rxdart/subjects.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';

class DataController {
  final BehaviorSubject<ChartData> _controller = BehaviorSubject<ChartData>.seeded(ChartData());

  Stream<ChartData> get stream => _controller.stream;

  Sink<ChartData> get sink => _controller.sink;

  void dispose() {
    if (!_controller.isClosed) _controller.close();
  }
}
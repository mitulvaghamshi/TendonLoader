import 'package:rxdart/subjects.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';

class DataHandler {
  final BehaviorSubject<ChartData> _controller = BehaviorSubject<ChartData>.seeded(const ChartData());

  Stream<ChartData> get stream => _controller.stream;

  Sink<ChartData> get sink => _controller.sink;

  void clear() => sink.add(const ChartData());

  void dispose() {
    if (!_controller.isClosed) _controller.close();
  }
}

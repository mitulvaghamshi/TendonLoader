import 'package:rxdart/rxdart.dart';
import 'package:tendon_loader/shared/modal/data_model.dart';

mixin ClickHandler {
  static final BehaviorSubject<DataModel> _clickCtrl = BehaviorSubject<DataModel>();

  static Stream<DataModel> get stream => _clickCtrl.stream;

  static Sink<DataModel> get sink => _clickCtrl.sink;

  static void dispose() {
    if (!_clickCtrl.isClosed) _clickCtrl.close();
  }
}

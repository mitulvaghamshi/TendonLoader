import 'package:rxdart/rxdart.dart';
import 'package:tendon_loader/web/handler/item_click_handler.dart';

mixin ItemClickController {
  static final BehaviorSubject<ItemClickHandler> _clickCtrl = BehaviorSubject<ItemClickHandler>();

  static Stream<ItemClickHandler> get stream => _clickCtrl.stream;

  static Sink<ItemClickHandler> get sink => _clickCtrl.sink;

  static void dispose() {
    if (!_clickCtrl.isClosed) _clickCtrl.close();
  }
}

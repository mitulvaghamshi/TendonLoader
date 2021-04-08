import 'package:rxdart/rxdart.dart';

mixin FilePath {
  static final BehaviorSubject<String> _pathCtrl = BehaviorSubject<String>();

  static Stream<String> get stream => _pathCtrl.stream;

  static Sink<String> get sink => _pathCtrl.sink;

  static void dispose() {
    if (!_pathCtrl.isClosed) _pathCtrl.close();
  }
}

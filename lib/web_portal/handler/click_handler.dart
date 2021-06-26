import 'package:rxdart/rxdart.dart'  ;
import 'package:tendon_loader/modal/export.dart';
 
final BehaviorSubject<Export> _clickCtrl = BehaviorSubject<Export>();

Stream<Export> get exportItemStream => _clickCtrl.stream;

Sink<Export> get exportItemSink => _clickCtrl.sink;

void disposeItemHandler() {
  if (!_clickCtrl.isClosed) _clickCtrl.close();
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

mixin UserReference {
  static final BehaviorSubject<DocumentReference> _pathCtrl = BehaviorSubject<DocumentReference>();

  static Stream<DocumentReference> get stream => _pathCtrl.stream;

  static Sink<DocumentReference> get sink => _pathCtrl.sink;

  static void dispose() {
    if (!_pathCtrl.isClosed) _pathCtrl.close();
  }
}

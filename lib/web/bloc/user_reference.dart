import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

mixin UserReference {
  static final BehaviorSubject<CollectionReference> _pathCtrl = BehaviorSubject<CollectionReference>();

  static Stream<CollectionReference> get stream => _pathCtrl.stream;

  static Sink<CollectionReference> get sink => _pathCtrl.sink;

  static void dispose() {
    if (!_pathCtrl.isClosed) _pathCtrl.close();
  }
}

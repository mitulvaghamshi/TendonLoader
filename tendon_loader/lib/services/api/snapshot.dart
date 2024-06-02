import 'package:flutter/cupertino.dart';

@immutable
final class Snapshot<T> {
  const Snapshot._(this.data, this.error)
      : assert(data == null || error == null, 'Cannot have data with error');

  const Snapshot.withData(T data) : this._(data, null);
  const Snapshot.withError(Object error) : this._(null, error);

  final T? data;
  final Object? error;

  bool get hasData => data != null;
  bool get hasError => error != null;

  T get requireData {
    if (hasData) return data!;
    if (hasError) Error.throwWithStackTrace(error!, StackTrace.empty);
    throw StateError('Snapshot has neither data nor error');
  }
}

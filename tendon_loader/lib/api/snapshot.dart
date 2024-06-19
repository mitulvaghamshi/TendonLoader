import 'package:flutter/cupertino.dart';

@immutable
class Snapshot<T> {
  const Snapshot._(this.data, this.error);

  const Snapshot.nothing() : this._(null, null);
  const Snapshot.withData(T data) : this._(data, null);
  const Snapshot.withError(String? error) : this._(null, error);

  final T? data;
  final String? error;

  bool get hasData => data != null;
  bool get hasError => error != null;

  T get requireData {
    if (hasData) return data!;
    if (hasError) Error.throwWithStackTrace(error!, StackTrace.empty);
    throw StateError('Snapshot has neither data nor error');
  }
}

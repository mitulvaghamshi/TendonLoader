interface class Snapshot<T> {
  const Snapshot.none() : _data = null, _error = null;
  const Snapshot.data(T data) : _data = data, _error = null;
  const Snapshot.error(String? error) : _data = null, _error = error;

  final T? _data;
  final String? _error;
}

extension Utils<T> on Snapshot<T> {
  bool get hasData => _data != null;
  bool get hasError => _error != null;

  T? get data => _data;
  String? get error => _error;

  T get requireData {
    if (hasData) {
      return _data!;
    }
    if (hasError) {
      return Error.throwWithStackTrace(_error!, .current);
    }
    throw StateError('Snapshot has no data');
  }
}

import 'package:tendon_loader/utils/modal/chart_data.dart';

mixin DataAdapter {
  static final List<ChartData> _collection = <ChartData>[];

  static List<ChartData> get collection => _collection;

  static bool get hasData => _collection.isNotEmpty;

  static void collect(ChartData chartData) => _collection.add(chartData);

  static void clear() => _collection.clear();

  static List<ChartData> average() {
    int count = 0;
    double _avgTime = 0;
    double _avgWeight = 0;
    final List<ChartData> _tempData = <ChartData>[];
    for (final ChartData chartData in _collection) {
      _avgTime += chartData.time;
      _avgWeight += chartData.load;
      if (count++ == 8) {
        _tempData.add(ChartData(
          time: double.parse((_avgTime / 8.0 / 1000000.0).toStringAsFixed(2)),
          load: double.parse((_avgWeight.abs() / 8.0).toStringAsFixed(2)),
        ));
        _avgWeight = _avgTime = 0;
        count = 0;
      }
    }
    return _tempData;
  }
}

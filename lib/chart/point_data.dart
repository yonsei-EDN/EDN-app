import 'package:statistics/statistics.dart';

class ChildPoint {
  final double x;
  final double y;

  ChildPoint({required this.x, required this.y});
}

List<ChildPoint> linearRegression(List<ChildPoint> points) {
  final int n = points.length;

  final List<double> dataX = points.map((e) => e.x).toList();
  final List<double> dataY = points.map((e) => e.y).toList();
  final List<double> dataX2 = dataX.square;
  final List<double> dataXY = points.map((e) => e.x * e.y).toList();

  final double meanX = dataX.mean;
  final double meanY = dataY.mean;

  final double b_1 =
      (dataXY.sum - n * meanX * meanY) / (dataX2.sum - n * meanX * meanX);

  final double b_0 = meanY - b_1 * meanX;

  return [
    ChildPoint(x: dataX.statistics.min, y: b_0 + b_1 * dataX.statistics.min),
    ChildPoint(x: dataX.statistics.max, y: b_0 + b_1 * dataX.statistics.max),
  ];
}

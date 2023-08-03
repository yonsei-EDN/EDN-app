import 'package:kidscan_app/chart/point_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<ChildPoint> points;
  final int idx;
  static List<String> titles = ['Height Record', 'Weight Record'];
  static List<String> units = ['cm', 'kg'];

  const LineChartWidget(this.points, this.idx, {super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LineChart(
        duration: const Duration(milliseconds: 500),
        LineChartData(
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              axisNameWidget: Text(
                titles[idx],
                style: const TextStyle(fontSize: 25),
              ),
              axisNameSize: 60,
            ),
            bottomTitles: const AxisTitles(
              axisNameWidget: Text(
                'days',
                style: TextStyle(fontSize: 15),
              ),
              axisNameSize: 40,
              sideTitles: SideTitles(reservedSize: 30, showTitles: true),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                units[idx],
                style: const TextStyle(fontSize: 15),
              ),
              axisNameSize: 15,
              sideTitles: const SideTitles(
                reservedSize: 35,
                showTitles: true,
                interval: 5,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          minY: [78.0, 10.0].elementAt(idx),
          minX: 3.0,
          maxX: 50.0,
          maxY: 140,
          lineBarsData: [
            LineChartBarData(
              spots: linearRegression(points)
                  .map((point) => FlSpot(point.x, point.y))
                  .toList(),
              isCurved: false,
              dotData: const FlDotData(show: false),
              color: Colors.red,
            ),
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: false,
            )
          ],
          backgroundColor: Colors.orange[50],
        ),
      ),
    );
  }
}

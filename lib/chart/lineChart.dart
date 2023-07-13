import 'package:firstapp/chart/point_data.dart';
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
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              axisNameWidget: Text(
                titles[idx],
                style: TextStyle(fontSize: 40),
              ),
              axisNameSize: 60,
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(
                'days',
                style: TextStyle(fontSize: 25),
              ),
              axisNameSize: 40,
              sideTitles: SideTitles(reservedSize: 30, showTitles: true),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                units[idx],
                style: TextStyle(fontSize: 15),
              ),
              axisNameSize: 30,
              sideTitles:
                  SideTitles(reservedSize: 40, showTitles: true, interval: 5),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
          ),
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: false,
              dotData: FlDotData(show: true),
            )
          ],
        ),
      ),
    );
  }
}

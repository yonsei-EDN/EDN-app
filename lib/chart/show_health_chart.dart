import 'package:kidscan_app/chart/line_chart.dart';
import 'package:kidscan_app/chart/point_data.dart';
import 'package:flutter/material.dart';

import '../modify_api/child.dart';
import '../modify_api/mod_service.dart';

const int userId = 5;

class DrawHealthChart extends StatefulWidget {
  const DrawHealthChart({super.key});

  @override
  State<DrawHealthChart> createState() => _DrawHealthChartState();
}

class _DrawHealthChartState extends State<DrawHealthChart> {
  bool loading = false;
  List<ChildPoint> childPointsHeight = <ChildPoint>[];
  List<ChildPoint> childPointsWeight = <ChildPoint>[];

  Child userChild = Child(birhtday: DateTime.now(), record: <Record>[], id: 0);
  @override
  void initState() {
    super.initState();

    Services.getInfo().then((childs) {
      setState(() {
        userChild = childs[0];
        for (int i = 0; i < childs.length; i++) {
          if (childs[i].id == userId) {
            userChild = childs[i];
            var birth = userChild.birhtday;
            var record = userChild.record;
            for (int i = 0; i < record.length; i++) {
              var height = record[i].height;
              var weight = record[i].weight;
              var days = record[i].updated.difference(birth).inDays.toDouble();

              childPointsHeight.add(ChildPoint(x: days, y: height));
              childPointsWeight.add(ChildPoint(x: days, y: weight));
            }

            break;
          }
        }
        loading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar:
          AppBar(title: Text(loading ? 'Child Health Record' : 'Loading...')),
      body: ListView(
        children: [
          LineChartWidget(childPointsHeight, 0),
          const SizedBox(height: 30),
          LineChartWidget(childPointsWeight, 1),
        ],
      ),
    );
  }
}

import 'package:firstapp/chart/lineChart.dart';
import 'package:firstapp/chart/point_data.dart';
import 'package:flutter/material.dart';

import '../modify_api/child.dart';
import '../modify_api/mod_service.dart';

const int user_id = 5;

class DrawHealthChart extends StatefulWidget {
  const DrawHealthChart({super.key});

  @override
  State<DrawHealthChart> createState() => _DrawHealthChartState();
}

class _DrawHealthChartState extends State<DrawHealthChart> {
  bool loading = false;
  List<ChildPoint> childPoints_height = <ChildPoint>[];
  List<ChildPoint> childPoints_weight = <ChildPoint>[];

  Child user_child = Child(birhtday: DateTime.now(), record: <Record>[], id: 0);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Services.getInfo().then((Childs) {
      setState(() {
        user_child = Childs[0];
        for (int i = 0; i < Childs.length; i++) {
          if (Childs[i].id == user_id) {
            user_child = Childs[i];
            var birth = user_child.birhtday;
            var record = user_child.record;
            for (int i = 0; i < record.length; i++) {
              var height = record[i].height;
              var weight = record[i].weight;
              var days = record[i].updated.difference(birth).inDays.toDouble();

              childPoints_height.add(ChildPoint(x: days, y: height));
              childPoints_weight.add(ChildPoint(x: days, y: weight));
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
          LineChartWidget(childPoints_height, 0),
          SizedBox(height: 30),
          LineChartWidget(childPoints_weight, 1),
        ],
      ),
    );
  }
}

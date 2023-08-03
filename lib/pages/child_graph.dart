import 'package:flutter/material.dart';
import 'package:kidscan_app/api/auth_api.dart';
import 'package:kidscan_app/api/child_api.dart';
import 'package:kidscan_app/api/child_record_api.dart';
import 'package:kidscan_app/chart/line_chart.dart';
import 'package:kidscan_app/chart/point_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthAPI.login('chonahyun0615@edndev.net', '!!43214321');
  int idid = -1;
  await ChildAPI.list().then((value) {
    idid = value[0].id;
  }).catchError((e) {
    debugPrint(e);
  });
  debugPrint(idid.toString());
  runApp(
    MaterialApp(
      // showSemanticsDebugger: true,
      home: Scaffold(
        appBar: AppBar(title: const Text('차트')),
        body: ChildGraph(childId: idid),
      ),
    ),
  );
}

class ChildGraph extends StatefulWidget {
  final int childId;
  const ChildGraph({super.key, required this.childId});

  @override
  State<ChildGraph> createState() => _ChildGraphState();
}

class _ChildGraphState extends State<ChildGraph> {
  bool loading = true;
  late final int lenRecord;
  late final DateTime birth;
  late final String name;

  late final List<ChildPoint> childPointsHeight;
  late final List<ChildPoint> childPointsWeight;

  Future<void> loadData() async {
    final currChild = await ChildAPI.read(widget.childId);
    final currChildRecords = await ChildRecordAPI.list(widget.childId);

    lenRecord = currChildRecords.length;
    birth = currChild.birthday;
    name = currChild.name;
    setState(() {
      childPointsHeight = currChildRecords.map<ChildPoint>((rec) {
        double days = rec.updated.difference(birth).inDays.toDouble();
        return ChildPoint(x: days, y: rec.height);
      }).toList();
      childPointsWeight = currChildRecords.map<ChildPoint>((rec) {
        double days = rec.updated.difference(birth).inDays.toDouble();
        return ChildPoint(x: days, y: rec.weight);
      }).toList();
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : chartBuilder();
  }

  Widget chartBuilder() {
    int days = DateTime.now().difference(birth).inDays;
    return SingleChildScrollView(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    '우리 $name,\n태어난 지 $days일',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: LineChartWidget(childPointsHeight, 0),
                  ),
                  // const SizedBox(height: 30),
                  // LineChartWidget(childPointsWeight, 1),
                ],
              ),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}

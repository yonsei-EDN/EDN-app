import 'package:firstapp/information_input/profile_record.dart';
import 'package:firstapp/local_txt/profile_show.dart';
import 'package:flutter/material.dart';

import 'chart/show_health_chart.dart';
import 'information_input/birth_modify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Character card',
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('우리 아이 성장 기록하기'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: Size(120, 70)),
              child: Text('기록하기', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileRecord(),
                    ));
              },
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: Size(120, 70)),
              child: Text('우리 아이\n성장 일지 리스트', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileShow(),
                    ));
              },
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: Size(120, 70)),
              child: Text('우리 아이\n성장 곡선', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DrawHealthChart(),
                    ));
              },
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: Size(120, 70)),
              child: Text('생일 바꾸기', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BirthModify(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

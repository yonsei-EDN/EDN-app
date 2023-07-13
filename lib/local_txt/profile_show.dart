import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ProfileShow extends StatelessWidget {
  const ProfileShow({super.key});

  @override
  Widget build(BuildContext context) {
    return MyCustom(storage: Storage());
  }
}

class MyCustom extends StatefulWidget {
  const MyCustom({super.key, required this.storage});

  final Storage storage;

  @override
  State<MyCustom> createState() => _MyCustomState();
}

class _MyCustomState extends State<MyCustom> {
  List<String> records = [''];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        records = value;
        loading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(loading ? 'Record List' : 'Loading...')),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: recordLines(records),
          ),
        ),
      ),
    );
  }
}

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/health_profile.txt');
  }

  Future<List<String>> readCounter() async {
    try {
      final file = await _localFile;
      // Read the file
      final contents = await file.readAsString();
      return contents.trim().split('\n');
    } catch (e) {
      // If encountering an error, return 0
      return ['에러가 났습니다.'];
    }
  }
}

List<Text> recordLines(List<String> data) {
  List<Text> temp = [Text('지금까지의 기록')];
  List<String> listr = [];
  String str = '';
  print('Im OK');
  print(data);
  if (data.isNotEmpty) {
    for (int i = 0; i < data.length; i++) {
      listr = data[i].split(',');
      if (listr.length == 5) {
        str =
            "<${listr[0]}년 ${listr[1]}월 ${listr[2]}일>\n 키 : ${listr[3]}cm, 몸무게 : ${listr[4]}kg\n";
        temp.add(Text(
          str,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ));
      }
    }
  }
  return temp;
}

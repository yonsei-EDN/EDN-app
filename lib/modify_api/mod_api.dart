import 'package:firstapp/modify_api/mod_service.dart';
import 'package:firstapp/modify_api/child.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const int user_id = 5;

class ChildJson extends StatefulWidget {
  const ChildJson({super.key});

  @override
  State<ChildJson> createState() => _ChildJsonState();
}

class _ChildJsonState extends State<ChildJson> {
  final List<Child> _Childs = <Child>[];
  final List<Record> _Records = <Record>[];
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Services.getInfo().then((Childs) {
      setState(() {
        _Childs.addAll(Childs);

        for (int i = 0; i < _Childs.length; i++) {
          if (_Childs[i].id == user_id) {
            Child child = _Childs[i];
            _Records.addAll(child.record);
          }
        }

        loading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loading ? 'Child Json' : 'Loading'),
      ),
      body: ListView.builder(
        itemCount: _Records.length,
        itemBuilder: (context, index) {
          Record record = _Records[index];
          return ListTile(
            leading: const Icon(Icons.child_care),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Text('${record.height}cm and ${record.weight}kg'),
            subtitle: Text(record.updated.toString()),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const My_App());
}

class My_App extends StatelessWidget {
  const My_App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ChildJson(),
    );
  }
}

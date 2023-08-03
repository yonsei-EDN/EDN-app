import 'package:flutter/material.dart';
import 'package:kidscan_app/login.dart';
// import 'package:temporal/pages/chatbot.dart';
// import 'package:temporal/pages/homepage.dart';
// import 'package:temporal/prac/information.dart';
// import 'package:temporal/pages/show_record_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'navigate demo',
      // theme: ThemeData(
      //   // primarySwatch: Colors.teal,
      //   colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal),
      //   useMaterial3: true,
      //   fontFamily: 'Material Symbols',
      // ),
      home: LoginPage(),
      // routes: {
      //   '/homepage': (context) => HomePage(),
      //   // '/show_record_list': (context) => ShowRecordList(),
      //   // '/chatbot': (context) => ChatBot(),
      //   '/information': (context) => Information(),
      // },
    );
  }
}

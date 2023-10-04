import 'package:flutter/material.dart';
import 'package:kidscan_app/api/auth_api.dart';
import 'package:kidscan_app/api/child_api.dart';
import 'package:kidscan_app/login.dart';
import 'package:kidscan_app/models/child.dart';
import 'package:kidscan_app/pages/homepage.dart';
// import 'package:temporal/pages/chatbot.dart';
// import 'package:temporal/pages/homepage.dart';
// import 'package:temporal/prac/information.dart';
// import 'package:temporal/pages/show_record_list.dart';

String myEmail = 'chonahyun0615@edndev.net';
String myPassword = '!!43214321';
late final int userChildId;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthAPI.login(myEmail, myPassword);

  final List<Child> userChilds = await ChildAPI.list();
  userChildId = userChilds[0].id;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'navigate demo',
      // theme: ThemeData(
      //   // primarySwatch: Colors.teal,
      //   colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal),
      //   useMaterial3: true,
      //   fontFamily: 'Material Symbols',
      // ),
      home: HomePage(childId: userChildId), //LoginPage(),
      // routes: {
      //   '/homepage': (context) => HomePage(),
      //   // '/show_record_list': (context) => ShowRecordList(),
      //   // '/chatbot': (context) => ChatBot(),
      //   '/information': (context) => Information(),
      // },
    );
  }
}

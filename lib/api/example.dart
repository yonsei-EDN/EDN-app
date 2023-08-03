import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidscan_app/api/auth_api.dart';
import 'package:kidscan_app/api/child_record_api.dart';
// import 'package:kidscan_app/api/child_record_api.dart';
import 'package:kidscan_app/models/child_record.dart';
// import 'package:temporal/models/child_record.dart';

String myEmail = 'chonahyun0615@edndev.net';
String myPassword = '!!43214321';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await AuthAPI.register(myEmail, myPassword, myPassword);
  await Future.delayed(const Duration(seconds: 2));
  await AuthAPI.login(myEmail, myPassword);
  bool t = await AuthAPI.isUserLoggedIn();
  debugPrint('is it logged in? : $t');
  // ChildAPI.create(Child(name: 'test1', birthday: DateTime(2020, 1, 5)));
  List<ChildRecord> listmy = await ChildRecordAPI.list(2);
  for (ChildRecord c in listmy) {
    debugPrint(c.toString());
  }

  await AuthAPI.logout();
  t = await AuthAPI.isUserLoggedIn();
  debugPrint('is it logged in? : $t');
  debugPrint('finished');
}

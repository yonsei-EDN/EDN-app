import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kidscan_app/modify_api/child.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Services {
  static const url = 'http://api.edndev.net/api/v1/child_record';

  static Future<List<Child>> getInfo() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (true) {
        // 로컬에서 json 파일을 읽어옴
        final String responseString =
            await rootBundle.loadString('assets/temp.json');
        final List<Child> Childs = childFromJson(responseString);
        return Childs;
      } else {
        Fluttertoast.showToast(msg: 'Please try again later');
        return List<Child>.empty();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return List<Child>.empty();
    }
  }
}

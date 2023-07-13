import 'dart:convert';

import 'package:firstapp/api/api.dart';
import 'package:http/http.dart' as http;

class ChildRecordAPI {
  static const String uri = 'http://api.edndev.net/api/v1/child_record';

  static Future<List<ChildRecord>> list() async {
    List<ChildRecord> childRecords = [];
    final url = Uri.parse('$uri/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> maps = jsonDecode(response.body);
      for (final map in maps) {
        childRecords.add(ChildRecord.fromMap(map));
      }
    } else {/* request fails */}
    return childRecords;
  }

  static Future<ChildRecord> read(int id) async {
    final url = Uri.parse('$uri/$id/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return ChildRecord.fromMap(jsonDecode(response.body));
    } else {
      /* request fails */ throw Error;
    }
  }

  static Future<ChildRecord> create(ChildRecord entity) async {
    final url = Uri.parse('$uri/');
    var data = entity.toMap();
    data.remove('id');
    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data));
      return ChildRecord.fromMap(jsonDecode(res.body));
    } catch (e) {
      /* request fails */
      throw Error;
    }
  }

  static Future<void> delete(int id) async {
    final url = Uri.parse('$uri/$id/');
    final res = await http.delete(url);
    if (res.statusCode == 204) {
      return;
    } else {
      /* request fails */ throw Error;
    }
  }
}

void main() async {
  List<ChildRecord> childRecords = await ChildRecordAPI.list();
  for (final entity in childRecords) {
    if (entity.id != -1) {
      ChildRecord childRecord = await ChildRecordAPI.read(entity.id);
      print(childRecord);
    }
  }
}

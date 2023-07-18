import 'dart:convert' show jsonEncode;
import 'package:http/http.dart' as http;

import 'package:kidscan_app/api/auth_api.dart' as auth_api;
import 'package:kidscan_app/api/common.dart' as api_common;
import 'package:kidscan_app/api/exceptions.dart' as api_exceptions;

import 'package:kidscan_app/models/child_record.dart' show ChildRecord;


class ChildRecordAPI {

  static const String uri = '${api_common.apiBaseUri}/child_management/child_height_weight_record';

  static Future<List<ChildRecord>> list(int childId) async {
    await api_common.checkAll(loginRequired: true);
    List<ChildRecord> childRecords = [];
    final url = Uri.parse('$uri/$childId/');
    final response = await http.get(url, headers: await api_common.addAuthHeader());
    if (response.statusCode == 200) {
      final List<dynamic> maps = api_common.decodeBody(response);
      for (final map in maps) {
        childRecords.add(ChildRecord.fromJson(map));
      }
    } else {/* request fails */throw api_exceptions.UnwantedResponse(response);}
    return childRecords;
  }

  static Future<ChildRecord> read(int childId, int id) async {
    await api_common.checkAll(loginRequired: true);
    final url = Uri.parse('$uri/$childId/$id/');
    final response = await http.get(url, headers: await api_common.addAuthHeader());
    if (response.statusCode == 200) {
      return ChildRecord.fromJson(api_common.decodeBody(response));
    } else {/* request fails */throw api_exceptions.UnwantedResponse(response);}
  }

  static Future<ChildRecord> create(int childId, ChildRecord entity) async {
    await api_common.checkAll(loginRequired: true);
    final url = Uri.parse('$uri/$childId/');
    var data = entity.toJson();
    data.remove('id');
    try {
      final response = await http.post(
          url,
          headers: await api_common.addAuthHeader(api_common.defaultPostHeaders),
          body: jsonEncode(data)
      );
      if (response.statusCode == 201) {
        return ChildRecord.fromJson(api_common.decodeBody(response));
      } else {/* request fails */throw api_exceptions.UnwantedResponse(response);}
    } on http.ClientException catch (e) {/* request fails */throw api_exceptions.FailedRequest(e);}
  }

  static Future<ChildRecord> update(int childId, ChildRecord entity) async {
    await api_common.checkAll(loginRequired: true);
    final url = Uri.parse('$uri/$childId/${entity.id}/');
    assert (entity.id != -1);
    var data = entity.toJson();
    try {
      final response = await http.put(
          url,
          headers: await api_common.addAuthHeader(api_common.defaultPostHeaders),
          body: jsonEncode(data)
      );
      if (response.statusCode == 200) {
        assert (entity == ChildRecord.fromJson(api_common.decodeBody(response)));
        return entity;
      } else {/* request fails */throw api_exceptions.UnwantedResponse(response);}
    } on http.ClientException catch (e) {/* request fails */throw api_exceptions.FailedRequest(e);}
  }

  static Future<void> delete(int childId, int id) async {
    await api_common.checkAll(loginRequired: true);
    final url = Uri.parse('$uri/$childId/$id/');
    final response = await http.delete(url, headers: await api_common.addAuthHeader());
    if (response.statusCode != 204) /* request fails */throw api_exceptions.UnwantedResponse(response);
  }

}


// Unit test
void main() async {
  // await auth_api.AuthAPI.register("username@email.com", "pass1!word!!", "pass1!word!!");
  await auth_api.AuthAPI.login("username@email.com", "pass1!word!!");
  int childId = 1;
  ChildRecord created = await ChildRecordAPI.create(childId, ChildRecord(height: 12, weight: 34));
  List<ChildRecord> childRecords = await ChildRecordAPI.list(childId);
  for (final entity in childRecords) {
    if (entity.id != -1) {
      ChildRecord childRecord = await ChildRecordAPI.read(childId, entity.id);
      print(childRecord);
    }
  }
  await ChildRecordAPI.delete(childId, created.id);
}

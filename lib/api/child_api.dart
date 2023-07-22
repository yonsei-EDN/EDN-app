import 'dart:io';
import 'dart:convert' show jsonEncode;
import 'package:http/http.dart' as http;

import 'package:kidscan_app/api/auth_api.dart' as auth_api;
import 'package:kidscan_app/api/common.dart' as api_common;
import 'package:kidscan_app/api/exceptions.dart' as api_exceptions;

import 'package:kidscan_app/models/child.dart' show Child;


class ChildAPI {

  static const String uri = '${api_common.apiBaseUri}/child_management/child';

  static Future<List<Child>> list() async {
    await api_common.checkAll(loginRequired: true);
    List<Child> children = [];
    final url = Uri.parse('$uri/');
    final response = await http.get(url, headers: await api_common.addAuthHeader());
    if (response.statusCode == 200) {
      final List<dynamic> maps = api_common.decodeBody(response);
      for (final map in maps) {
        children.add(Child.fromJson(map));
      }
    } else {/* request fails */throw api_exceptions.UnwantedResponse(response);}
    return children;
  }

  static Future<Child> read(int id) async {
    await api_common.checkAll(loginRequired: true);
    final url = Uri.parse('$uri/$id/');
    final response = await http.get(url, headers: await api_common.addAuthHeader());
    if (response.statusCode == 200) {
      return Child.fromJson(api_common.decodeBody(response));
    } else {/* request fails */throw api_exceptions.UnwantedResponse(response);}
  }

  static Future<Child> create(Child entity) async {
    await api_common.checkAll(loginRequired: true);
    final url = Uri.parse('$uri/');
    var data = entity.toJson();
    data.remove('id');
    try {
      final response = await http.post(
          url,
          headers: await api_common.addAuthHeader(api_common.defaultPostHeaders),
          body: jsonEncode(data)
      );
      if (response.statusCode == 201) {
        return Child.fromJson(api_common.decodeBody(response));
      } else {/* request fails */throw api_exceptions.UnwantedResponse(response);}
    } on http.ClientException catch (e) {/* request fails */throw api_exceptions.FailedRequest(e);}
  }

  static Future<Child> update(Child entity) async {
    await api_common.checkAll(loginRequired: true);
    final url = Uri.parse('$uri/${entity.id}/');
    assert (entity.id != -1);
    var data = entity.toJson();
    try {
      final response = await http.put(
          url,
          headers: await api_common.addAuthHeader(api_common.defaultPostHeaders),
          body: jsonEncode(data)
      );
      if (response.statusCode == 200) {
        assert (entity == Child.fromJson(api_common.decodeBody(response)));
        return entity;
      } else {/* request fails */throw api_exceptions.UnwantedResponse(response);}
    } on http.ClientException catch (e) {/* request fails */throw api_exceptions.FailedRequest(e);}
  }

  static Future<void> delete(int id) async {
    await api_common.checkAll(loginRequired: true);
    final url = Uri.parse('$uri/$id/');
    final response = await http.delete(url, headers: await api_common.addAuthHeader());
    if (response.statusCode != 204) /* request fails */throw api_exceptions.UnwantedResponse(response);
  }

}


// Unit test
void main() async {
  print("enter your email: ");
  String email = stdin.readLineSync()!;
  print(email);
  print("enter your password: ");
  String password = stdin.readLineSync()!;
  // await auth_api.AuthAPI.register(email, password, password);
  await auth_api.AuthAPI.login(email, password);
  Child created = await ChildAPI.create(Child(name: "Dongha", birthday: DateTime(2001, 7, 27)));
  List<Child> childRecords = await ChildAPI.list();
  for (final entity in childRecords) {
    if (entity.id != -1) {
      Child childRecord = await ChildAPI.read(entity.id);
      print(childRecord);
    }
  }
  await ChildAPI.delete(created.id);
}

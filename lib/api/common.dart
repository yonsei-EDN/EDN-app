import 'dart:convert' show jsonDecode, utf8;
import 'package:http/http.dart' as http;

import 'package:kidscan_app/api/auth_api.dart' as auth_api;


// const String apiBaseUri = 'http://api.edndev.net/api/v1';
const String apiBaseUri = 'http://localhost:8000/api/v1';


const Map<String, String> defaultPostHeaders = {"Content-Type": "application/json"};


dynamic decodeBody(http.Response response) => jsonDecode(utf8.decode(response.bodyBytes));


Future<Map<String, String>> addAuthHeader([Map<String, String>? original]) async {
  return await auth_api.AuthAPI.addAuthHeader(original);
}


Future<void> checkAll({bool loginRequired = false}) async {
  await auth_api.AuthAPI.checkAll(loginRequired: loginRequired);
}

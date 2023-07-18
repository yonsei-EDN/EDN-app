import 'package:http/http.dart' as http;

import 'package:kidscan_app/api/common.dart' as api_common;


class APIError extends Error {}


class LoginRequired extends APIError {}


class UnwantedResponse extends APIError {
  final http.Response response;
  UnwantedResponse(this.response);
  int get statusCode => response.statusCode;
  Map<String, dynamic> get body => response.body.isEmpty ? {} : api_common.decodeBody(response);
  @override
  String toString() => '$runtimeType: $statusCode ${response.reasonPhrase}${body.isEmpty? '': ' - $body'}';
}


class FailedRequest extends APIError {
  final String message;
  final Uri? uri;
  FailedRequest(http.ClientException e) : message = e.message, uri = e.uri;
  @override
  String toString() => '$runtimeType: $message, ${null == uri? '': 'uri=$uri'}';
}

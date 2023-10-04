import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kidscan_app/api/common.dart' as api_common;
import 'package:kidscan_app/api/exceptions.dart' as api_exceptions;

abstract class AuthTokenWrapper {
  Future<int?> getUserPK();
  Future<String?> getUserEmail();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> setUserPK(int pk);
  Future<void> setUserEmail(String email);
  Future<void> setAccessToken(String token);
  Future<void> setRefreshToken(String token);
  Future<void> deleteUserPK();
  Future<void> deleteUserEmail();
  Future<void> deleteAccessToken();
  Future<void> deleteRefreshToken();
  Future<void> update({
    int? userPK,
    String? userEmail,
    String? accessToken,
    String? refreshToken,
  }) async {
    if (null != userPK) await setUserPK(userPK);
    if (null != userEmail) await setUserEmail(userEmail);
    if (null != accessToken) await setAccessToken(accessToken);
    if (null != refreshToken) await setRefreshToken(refreshToken);
  }

  Future<void> clear() async {
    await deleteUserPK();
    await deleteUserEmail();
    await deleteAccessToken();
    await deleteRefreshToken();
  }
}

class TemporaryAuthTokenWrapper extends AuthTokenWrapper {
  TemporaryAuthTokenWrapper._();
  static final TemporaryAuthTokenWrapper instance =
      TemporaryAuthTokenWrapper._();
  factory TemporaryAuthTokenWrapper() => instance; // Make it as singleton
  static int? _userPK;
  static String? _userEmail;
  static String? _accessToken;
  static String? _refreshToken;
  @override
  Future<int?> getUserPK() async => _userPK;
  @override
  Future<String?> getUserEmail() async => _userEmail;
  @override
  Future<String?> getAccessToken() async => _accessToken;
  @override
  Future<String?> getRefreshToken() async => _refreshToken;
  @override
  Future<void> setUserPK(int pk) async => _userPK = pk;
  @override
  Future<void> setUserEmail(String email) async => _userEmail = email;
  @override
  Future<void> setAccessToken(String token) async => _accessToken = token;
  @override
  Future<void> setRefreshToken(String token) async => _refreshToken = token;
  @override
  Future<void> deleteUserPK() async => _userPK = null;
  @override
  Future<void> deleteUserEmail() async => _userEmail = null;
  @override
  Future<void> deleteAccessToken() async => _accessToken = null;
  @override
  Future<void> deleteRefreshToken() async => _refreshToken = null;
}

class FlutterAuthTokenWrapper extends AuthTokenWrapper {
  FlutterAuthTokenWrapper._();
  static final FlutterAuthTokenWrapper instance = FlutterAuthTokenWrapper._();
  factory FlutterAuthTokenWrapper() => instance; // Make it as singleton
  static const FlutterSecureStorage storage = FlutterSecureStorage();
  static const String userPKKey = 'auth-user-pk';
  static const String userEmailKey = 'auth-user-email';
  static const String jwtAccessTokenKey = 'jwt-auth-access-token';
  static const String jwtRefreshTokenKey = 'jwt-auth-refresh-token';
  @override
  Future<int?> getUserPK() async =>
      int.tryParse(await storage.read(key: userPKKey) ?? '');
  @override
  Future<String?> getUserEmail() async => await storage.read(key: userEmailKey);
  @override
  Future<String?> getAccessToken() async =>
      await storage.read(key: jwtAccessTokenKey);
  @override
  Future<String?> getRefreshToken() async =>
      await storage.read(key: jwtRefreshTokenKey);
  @override
  Future<void> setUserPK(int pk) async =>
      await storage.write(key: userPKKey, value: pk.toString());
  @override
  Future<void> setUserEmail(String email) async =>
      await storage.write(key: userEmailKey, value: email);
  @override
  Future<void> setAccessToken(String token) async =>
      await storage.write(key: jwtAccessTokenKey, value: token);
  @override
  Future<void> setRefreshToken(String token) async =>
      await storage.write(key: jwtRefreshTokenKey, value: token);
  @override
  Future<void> deleteUserPK() async => await storage.delete(key: userPKKey);
  @override
  Future<void> deleteUserEmail() async =>
      await storage.delete(key: userEmailKey);
  @override
  Future<void> deleteAccessToken() async =>
      await storage.delete(key: jwtAccessTokenKey);
  @override
  Future<void> deleteRefreshToken() async =>
      await storage.delete(key: jwtRefreshTokenKey);
}

class AuthAPI {
  static const String uri = '${api_common.apiBaseUri}/accounts';

  static final AuthTokenWrapper tokenWrapper =
      FlutterAuthTokenWrapper(); // TemporaryAuthTokenWrapper();

  static Future<void> login(String email, String password) async {
    await api_common.checkAll();
    final url = Uri.parse('$uri/login/');
    final http.Response response;
    try {
      response = await http.post(url,
          headers: api_common.defaultPostHeaders,
          body: jsonEncode({"email": email, "password": password}));
    } on http.ClientException catch (e) {
      /* request fails */ throw api_exceptions.FailedRequest(e);
    }
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = api_common.decodeBody(response);
      var userPK = data['user']['pk'];
      var userEmail = data['user']['email'];
      var accessToken = data['access'];
      var refreshToken = data['refresh'];
      await tokenWrapper.update(
        userPK: userPK,
        userEmail: userEmail,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } else {
      /* request fails */ throw api_exceptions.UnwantedResponse(response);
    }
  }

  static Future<void> logout() async {
    await api_common.checkAll();
    final url = Uri.parse('$uri/logout/');
    final http.Response response;
    try {
      response = await http.post(
        url,
        headers: await addAuthHeader(api_common.defaultPostHeaders),
      );
    } on http.ClientException catch (e) {
      /* request fails */ throw api_exceptions.FailedRequest(e);
    }
    if (response.statusCode != 200) {
      throw api_exceptions.UnwantedResponse(response);
    }
    await tokenWrapper.clear();
  }

  static Future<void> register(
      String email, String password1, String password2) async {
    await api_common.checkAll();
    final url = Uri.parse('$uri/registration/');
    assert(password1 == password2);
    final http.Response response;
    try {
      response = await http.post(url,
          headers: api_common.defaultPostHeaders,
          body: jsonEncode({
            "email": email,
            "password1": password1,
            "password2": password2
          }));
    } on http.ClientException catch (e) {
      /* request fails */ throw api_exceptions.FailedRequest(e);
    }
    if (response.statusCode == 201) {
      final Map<String, dynamic> data = api_common.decodeBody(response);
      var userPK = data['user']['pk'];
      var userEmail = data['user']['email'];
      var accessToken = data['access'];
      var refreshToken = data['refresh'];
      await tokenWrapper.update(
        userPK: userPK,
        userEmail: userEmail,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } else {
      /* request fails */ throw api_exceptions.UnwantedResponse(response);
    }
  }

  static Future<bool> isUserLoggedIn() async =>
      (await tokenWrapper.getUserPK() ?? -1) != -1;

  static Future<bool> isTokenExpired() async {
    final String? accessToken = await tokenWrapper.getAccessToken();
    if (null == accessToken) return true;
    return JwtDecoder.isExpired(accessToken);
  }

  static Future<void> checkAll({bool loginRequired = false}) async {
    if (loginRequired) await _checkLogin();
    await _checkToken();
  }

  static Future<void> _checkLogin() async {
    if (!(await isUserLoggedIn())) {
      throw api_exceptions.LoginRequired();
    }
  }

  static Future<void> _checkToken() async {
    if ((await isUserLoggedIn()) && (await isTokenExpired())) {
      await _refreshToken();
    }
  }

  static Future<void> _refreshToken() async {
    final url = Uri.parse('$uri/token/refresh/');
    final http.Response response;
    try {
      response = await http.post(url,
          headers: api_common.defaultPostHeaders,
          body: jsonEncode({"refresh": await tokenWrapper.getRefreshToken()}));
    } on http.ClientException catch (e) {
      /* request fails */ throw api_exceptions.FailedRequest(e);
    }
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = api_common.decodeBody(response);
      await tokenWrapper.setAccessToken(data['access']);
      if (data.containsKey('refresh')) {
        await tokenWrapper.setRefreshToken(data['refresh']);
      }
    } else {
      /* request fails */ throw api_exceptions.UnwantedResponse(response);
    }
  }

  static Future<Map<String, String>> addAuthHeader(
          [Map<String, String>? original]) async =>
      {
        ...original ?? {},
        if (await isUserLoggedIn())
          "Authorization": "Bearer ${await tokenWrapper.getAccessToken()}"
      };
}

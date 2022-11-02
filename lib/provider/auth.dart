import 'package:flutter/foundation.dart';

import '../common_methods/get_device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/http_exception.dart';

final String baseUrl = '${dotenv.get('API_URL')}/api';

class Auth with ChangeNotifier {
  String? _token;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_token != null) {
      return _token!;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    const url = '';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    final url = '$baseUrl/login';
    debugPrint(url);
    try {
      final response = await http.post(Uri.parse(url), body: {
        'email': email,
        'password': password,
      });

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        _token = responseData['data']['token'];
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({'token': _token});
        prefs.setString('userData', userData);
        // await addDeviceInfo();
      } else {
        throw HttpException(responseData['data']['error']);
      }

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('login error--->');
        // print(error);
      }
      rethrow;
    }
  }

  Future<String> _getFirebaseToken() async {
    await Firebase.initializeApp();
    final firebaseToken = await FirebaseMessaging.instance.getToken();

    return firebaseToken!;
  }

  Future<void> addDeviceInfo() async {
    final firebaseToken = await _getFirebaseToken();

    final url = '$baseUrl/fcm/token';
    final deviceInfo = await getDeviceInfo();

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'device_name': '${deviceInfo['deviceName']}',
          'device_version': '${deviceInfo['deviceVersion']}',
          'device_identification': '${deviceInfo['identifier']}',
          'app_version': '1',
          'token': firebaseToken,
          'extra_info': 'this need extra data when its lenghth is incresed',
        },
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // store firebase token locally
        final prefs = await SharedPreferences.getInstance();
        final notificationData = json.encode({'firebaseToken': firebaseToken});
        prefs.setString('notification', notificationData);
      } else {
        throw HttpException(responseData['data']['error']);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    // final extractedUserData =
    // json.decode(prefs.getString('userData')!) as Map<String, Object>;
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

    _token = extractedUserData['token'] as String;

    notifyListeners();

    return true;
  }

  void logout() async {
    _token = null;

    final prefs = await SharedPreferences.getInstance();

    // prefs.remove('userData'); // for clear perticular key
    prefs.clear(); //for clear all stored key in prefs
    notifyListeners();
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '../values/strings_en.dart';

class HttpRequest {
  var connStatus = false;

  final String baseUrl = '${dotenv.get('API_URL')}/api';
  // ignore: prefer_typing_uninitialized_variables
  var response;
  Future<dynamic> postRequest(
      String apiEndPoint, dynamic body, String authToken, context) async {
    final url = '$baseUrl/$apiEndPoint';
    // print(url);

    try {
      response = await http.post(Uri.parse(url), body: body, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      });
      // print(json.decode(response.body));
      if (context != null) {
        await validateResponse(response, context);
      }

      if (response.statusCode == 200) {
        return true;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> postRequestWithJson(
      String apiEndPoint, dynamic body, String authToken, context) async {
    final url = '$baseUrl/$apiEndPoint';
    // print(url);

    try {
      response = await http.post(Uri.parse(url), body: body, headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      });
      // print(json.decode(response.body));
      if (context != null) {
        await validateResponse(response, context);
      }

      if (response.statusCode == 200) {
        return true;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> putRequest(String id, String apiEndPoint, dynamic body,
      String authToken, context) async {
    final url = '$baseUrl/$apiEndPoint/$id';
    http.Response response;

    try {
      response = await http.put(Uri.parse(url), body: body, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      });
      // print(response.body);
      if (context != null) {
        await validateResponse(response, context);
      }

      if (response.statusCode == 200) {
        return true;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getRequest(String apiEndPoint, String authToken,
      {BuildContext? context, String? param}) async {
    var url = '$baseUrl/$apiEndPoint';
    if (kDebugMode) {
      print(url);
    }
    var isGet = true;
    if (param != null) {
      url = '$baseUrl/$apiEndPoint?$param';
    }
    log(url);
    if (context != null) {
      isGet = await connectivityStatus(context);
    }
    if (isGet) {
      if (!connStatus) {
        await checkConnectivity(context);
        connStatus = true;
      }

      try {
        final response = await http.get(Uri.parse(url), headers: {
          // 'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        });
        // checkConnectivity();
        if (context != null) {
          await validateResponse(response, context);
        }

        if (response.statusCode == 200) {
        log('get api called');
          return response;
        }
      } catch (error) {
        rethrow;
      }
    } else {
      showSnackbar(context, 'turn on mobile data or wifi');
    }
  }

  Future<dynamic> deleteRequest(String apiEndPoint, String authToken, context,
      {String? param}) async {
    var url = '$baseUrl/$apiEndPoint';
    if (param != null) {
      url = '$baseUrl/$apiEndPoint?$param';
    }
    if (kDebugMode) {
      print(url);
    }
    try {
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      });
      if (context != null) {
        await validateResponse(response, context);
      }

      if (response.statusCode == 200) {
        return response;
      }
      if (kDebugMode) {
        print('object');
        print(response.body);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  validateResponse(response, context) {
    switch (response.statusCode) {
      // OK
      case 200:
        {
          if (kDebugMode) {
            print(200);
          }
          // return response;
        }
        break;
      //bad request
      case 400:
        {
          if (kDebugMode) {
            print(400);
          }
        }
        break;
      //Unauthorized
      case 401:
        {
          if (kDebugMode) {
            print(401);
          }

          return showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                      title: const Text(TITLE_ERROR_AUTHENTICATION_FAIL),
                      content: const Text(TITLE_ERROR_LOGIN_AGAIN),
                      actions: [
                        TextButton(
                          child: const Text(TITLE_OKAY),
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', (Route<dynamic> route) => false);

                            Provider.of<Auth>(context, listen: false).logout();
                          },
                        )
                      ]));
        }
      // break;
      //Not Found
      case 404:
        {
          if (kDebugMode) {
            print(404);
          }

          return showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                      title: const Text(TITLE_ERROR_WENT_WRONG),
                      content: const Text(TITLE_ERROR_CONTACT_ADMINISTRATOR),
                      actions: [
                        TextButton(
                          child: Text(
                            TITLE_OKAY,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', (Route<dynamic> route) => false);
                          },
                        )
                      ]));
        }
      // break;

      default:
        {
          if (kDebugMode) {
            print('default');
          }
        }
        break;
    }
  }

  checkConnectivity(context) async {
    String url;
    if (dotenv.get('API_URL').contains('https://')) {
      url = dotenv.get('API_URL').replaceFirst('https://', '');
    } else {
      url = dotenv.get('API_URL').replaceFirst('http://', '');
    }
    try {
      final result = await InternetAddress.lookup(url);

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('connected');
        }
      }
    } on SocketException catch (_) {
      connStatus = false;
      if (kDebugMode) {
        print('not connected');
      }
      await showSnackbar(context, 'not connected with server');
    }
  }

  showSnackbar(context, msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // content: Text('Please check your internet connectivity and try again'),
        content: Text(msg),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<bool> connectivityStatus(context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (kDebugMode) {
        print('connectedwith mobile');
      }
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (kDebugMode) {
        print('connectedwith wifi');
      }

      return true;
    } else {
      if (kDebugMode) {
        print('not connected with internet');
      }
    }
    return false;
  }
}

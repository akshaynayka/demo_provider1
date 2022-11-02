import 'dart:convert';

import '../values/api_end_points.dart';

import '../model/app_required_data.dart';

import '../http_request/http_request.dart';
import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  // ignore: prefer_typing_uninitialized_variables
  final _authToken;
  AppData(this._authToken);

  final HttpRequest _httpRequest = HttpRequest();

  Future<AppRequiredData> fetchappDetails({BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(
        API_APP_DETAILS,
        _authToken,
        context: context,
      );

     // print('-------------');
      final extractedData = json.decode(response.body)['data'];
     // print(extractedData);
      final loadedData = AppRequiredData(
        minBuildNumber: extractedData['minBuildNumber'],
        playStoreBuildNumber: extractedData['playstoreBuildNumber'],
      );
      // print('hello-------');
      notifyListeners();
      return loadedData;
    } catch (error) {
      rethrow;

    }
  }
}

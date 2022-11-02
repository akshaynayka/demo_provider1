import 'package:flutter/material.dart';
import 'dart:convert';

import '../http_request/http_request.dart';
import '../values/api_end_points.dart';

class Status with ChangeNotifier {
  final String id;
  final String name;

  Status({
    required this.id,
    required this.name,
  });
}

class StatusList with ChangeNotifier {
  List<Status> _status = [];

  // ignore: prefer_typing_uninitialized_variables
  final _authToken;
  final HttpRequest _httpRequest = HttpRequest();

  StatusList(
    this._authToken,
    this._status,
  );

  List<Status> get status {
    return [..._status];
  }

  Future<void> fetchAllStatus({BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(API_STATUS, _authToken,
          context: context);

      final extractedData = json.decode(response.body);
      final List<Status> loadedData = [];
      extractedData['data']['statuss'].forEach((statusData) {
        loadedData.add(Status(
          id: statusData['id'].toString(),
          name: statusData['name'],
        ));
      });
      _status = loadedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}

import '../http_request/http_request.dart';
import '../values/api_end_points.dart';
import 'package:flutter/material.dart';

class Supports with ChangeNotifier {
 final  HttpRequest _httpRequest = HttpRequest();

  Future<bool> addSupportsData(supportData, context) async {
    var status = false;

    try {
      final response = await _httpRequest.postRequest(
          API_SUPPORTS, supportData, '', context);

      if (response == true) {
        status = true;
      }

      return status;
    } catch (error) {
      rethrow;
    }
  }
}

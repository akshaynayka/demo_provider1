import 'dart:convert';

import '../values/api_end_points.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../http_request/http_request.dart';

class Template with ChangeNotifier {
  final String? id;
  final String? template;
  Template({
    required this.id,
    required this.template,
  });
}

class TemplateList with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Template> _allTemplates = [];
  // ignore: prefer_typing_uninitialized_variables
  final _authToken;
  final HttpRequest _httpRequest = HttpRequest();
  Template selecetedTemplate = Template(id: null, template: '');
  TemplateList(this._authToken, this._allTemplates);

  List<Template> get allTemplates {
    return [..._allTemplates];
  }

  // Future<void> fetchAllTemplates({BuildContext? context}) async {
  //   try {
  //     final response = await _httpRequest.getRequest(API_TEMPLATE, _authToken,
  //         context: context);
  //     final List extractedData =
  //         json.decode(response.body)['data']['messageTemplates']['data'];
  //     final List<Template> loadedData = [];
  //     //print('${extractedData['data']['messageTemplates']['data']}');
  //     for (var templates in extractedData) {
  //       loadedData.add(Template(
  //           id: templates['id'].toString(), template: templates['template']));
  //     }
  //     final pref = await SharedPreferences.getInstance();
  //     final idResponse = pref.getString('templateId');
  //     // print(idResponse);
  //     if (idResponse != null) {
  //       selecetedTemplate = loadedData.firstWhere(
  //         (element) => element.id == idResponse,
  //       );
  //     }
  //     // print('prefData');
  //     // print(selecetedTemplate.template);
  //     _allTemplates = loadedData;

  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<void> fetchAllTemplateList({BuildContext? context}) async {
    var alldata = [];
    try {
      final response = await _httpRequest.getRequest(API_TEMPLATE, _authToken,
          context: context);

      final extractedData = json.decode(response.body);
      final List<Map> loadedData = [];
      extractedData['data']['messageTemplates']['data'].forEach((templateData) {
        loadedData.add({
          'id': templateData['id'].toString(),
          'template': templateData['template'],
        });
      });
      alldata = loadedData;
      final pref = await SharedPreferences.getInstance();

      await pref.setString('allTemlates', json.encode(alldata));

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<Template> fetchTemplateById(
      {BuildContext? context, required String id}) async {
    try {
      final response = await _httpRequest.getRequest(
          '$API_TEMPLATE/$id', _authToken) as Response;
      // print('object');
      // print(jsonDecode(response.body)['data']['messageTemplate']);
      final extractedData =
          jsonDecode(response.body)['data']['messageTemplate'];
      final extractedTemplate = Template(
          id: extractedData['id'].toString(),
          template: extractedData['template']);
      return extractedTemplate;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> saveSelectedTemplate(String templateId) async {
    final pref = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    final status = await pref.setString('selectedTemplateId', templateId);
    // print('saved');
    // print(status);
  }

  Future<bool> addTemplate(Template template, context) async {
    var status = false;
    try {
      final response = await _httpRequest.postRequest(
          API_TEMPLATE, {'template': template.template}, _authToken, context);

      if (response == true) {
        status = true;
      }
      notifyListeners();
      return status;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateTemplate(String id, Template newTemplate, context) async {
    var status = false;

    try {
      final response = await _httpRequest.putRequest(id, API_TEMPLATE,
          {'template': newTemplate.template!}, _authToken, context);

      if (response == true) {
        status = true;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    return status;
  }

  Future<bool> deleteTemplate(String id, context) async {
    try {
      final response = await _httpRequest.deleteRequest(
        '$API_TEMPLATE/$id',
        _authToken,
        context,
      );

      if (response.statusCode == 200) {
        return true;
      }
      // existingCustomer = null;

      notifyListeners();
      // fetchFavoriteCustomers();
    } catch (error) {
      rethrow;
    }
    return true;
  }
}

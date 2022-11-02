import 'dart:developer';

import '../http_request/http_request.dart';
import '../values/api_end_points.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class Appointment with ChangeNotifier {
  final String? id;
  final String customerId;
  final dynamic servicesId;
  final String appointmentDate;
  final String statusId;
  // final String statusId;
  final dynamic customer;
  final dynamic status;

  Appointment({
    this.id,
    required this.customerId,
    required this.servicesId,
    required this.appointmentDate,
    required this.statusId,
    this.customer,
    this.status,
  });
}

class Appointments with ChangeNotifier {
  List<Appointment> _allAppointments = [];
  List<Appointment> _todayAppointments = [];
  List<Appointment> _recentAppointments = [];
  final HttpRequest _httpRequest = HttpRequest();

  // ignore: prefer_typing_uninitialized_variables
  final _authToken;

  var _todayCounts = {
    'totalAppointments': '0',
    'totalCustomers': '0',
  };
  var _allCounts = {
    'totalAppointments': '0',
    'totalCustomers': '0',
  };
  Appointments(this._authToken, this._allAppointments);

  List<Appointment> get allAppointments {
    return [..._allAppointments];
  }

  List<Appointment> get todayAppointments {
    return [..._todayAppointments];
  }

  List<Appointment> get recentAppointments {
    return [..._recentAppointments];
  }

  Map get todayCounts {
    return _todayCounts;
  }

  Map get allCounts {
    return _allCounts;
  }

  Appointment findById(String id) {
    return _allAppointments.firstWhere((data) => data.id == id);
  }

  Future<void> rebuildWidget({BuildContext? context}) async {}

  resetAppointmentWithPagination() {
    _allAppointments = [];
    _todayAppointments = [];
    _recentAppointments = [];
  }

  Future<Map> fetchRecentAppointment(int page, {BuildContext? context}) async {
    final today = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());

    var pages = {'currentPage': 1, 'lastPage': 1};
    if (page == 1) {
      _recentAppointments = [];
    }

    try {
      final response = await _httpRequest.getRequest(
        API_APPOINTMENTS,
        _authToken,
        param:
            'page=$page&sort[]=appointment_date,asc&appointment_date=(gt)$today%',
        context: context,
      );

      final extractedData = json.decode(response.body);

      final List<Appointment> loadedData = [];
      extractedData['data']['appointments']['data'].forEach((appointmentData) {
        loadedData.add(Appointment(
          id: appointmentData['id'].toString(),
          customerId: appointmentData['customer_id'].toString(),
          servicesId: appointmentData['services'],
          appointmentDate: appointmentData['appointment_date'],
          statusId: appointmentData['status']['id'].toString(),
          customer: appointmentData['customer'],
          status: appointmentData['status'],
        ));
      });
      _recentAppointments = _recentAppointments + loadedData;
      pages['currentPage'] =
          extractedData['data']['appointments']['current_page'];
      pages['lastPage'] = extractedData['data']['appointments']['last_page'];

      notifyListeners();
      return pages;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> fetchTodayAppointment(int page, {BuildContext? context}) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    var pages = {'currentPage': 1, 'lastPage': 1};
    if (page == 1) {
      _todayAppointments = [];
    }

    try {
      final response = await _httpRequest.getRequest(
        API_APPOINTMENTS,
        _authToken,
        param:
            'page=$page&sort[]=appointment_date,asc&appointment_date=$today%',
        context: context,
      );

      final extractedData = json.decode(response.body);
      final List<Appointment> loadedData = [];
      extractedData['data']['appointments']['data'].forEach((appointmentData) {
        loadedData.add(Appointment(
          id: appointmentData['id'].toString(),
          customerId: appointmentData['customer_id'].toString(),
          servicesId: appointmentData['services'],
          appointmentDate: appointmentData['appointment_date'],
          statusId: appointmentData['status']['id'].toString(),
          customer: appointmentData['customer'],
          status: appointmentData['status'],
        ));
      });
      _todayAppointments = _todayAppointments + loadedData;

      pages['currentPage'] =
          extractedData['data']['appointments']['current_page'];
      pages['lastPage'] = extractedData['data']['appointments']['last_page'];
      notifyListeners();
      return pages;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchTodayCount({BuildContext? context}) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      final response = await _httpRequest.getRequest(
          '$API_DASHBOARD/count', _authToken,
          context: context, param: 'appointment_date=$today');

      var todaytotalCount = json.decode(response.body)['data']['data'];
      _todayCounts = {
        'totalAppointments': todaytotalCount['appointment_total'].toString(),
        'totalCustomers': todaytotalCount['customer_total'].toString(),
      };
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAllCount({BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(
        '$API_DASHBOARD/count',
        _authToken,
        context: context,
      );

      var todaytotalCount = json.decode(response.body)['data']['data'];

      _allCounts = {
        'totalAppointments': todaytotalCount['appointment_total'].toString(),
        'totalCustomers': todaytotalCount['customer_total'].toString(),
      };
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  Future<Map> fetchAllAppointment(int page, {BuildContext? context}) async {
    var pages = {'currentPage': 1, 'lastPage': 1};
    if (page == 1) {
      _allAppointments = [];
    }

    try {
      final response = await _httpRequest.getRequest(
        API_APPOINTMENTS,
        _authToken,
        param: 'page=$page',
        context: context,
      );

      final extractedData = json.decode(response.body);
      // print(extractedData);
      log(extractedData['data']['appointments']['data'][0]['status']
          .toString());
      final List<Appointment> loadedData = [];
      extractedData['data']['appointments']['data'].forEach((appointmentData) {
        loadedData.add(Appointment(
          id: appointmentData['id'].toString(),
          customerId: appointmentData['customer_id'].toString(),
          servicesId: appointmentData['services'],
          appointmentDate: appointmentData['appointment_date'],
          statusId: appointmentData['status']['id'].toString(),
          customer: appointmentData['customer'],
          status: appointmentData['status'],
        ));
      });
      _allAppointments = _allAppointments + loadedData;
      pages['currentPage'] =
          extractedData['data']['appointments']['current_page'];
      pages['lastPage'] = extractedData['data']['appointments']['last_page'];

      notifyListeners();
      return pages;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> addAppointment(Appointment appointment, context) async {
    var status = false;
    var newAppointmentData = {
      'customer_id': appointment.customerId,
      // 'services_id[0]': appointment.servicesId,
      // 'services_id[1]': appointment.servicesId,
      'appointment_date': appointment.appointmentDate,
      'status_id': appointment.statusId,
    };

    for (var item in appointment.servicesId) {
      final itemId = item['id'].toString();
      newAppointmentData['service_ids[$itemId]'] = itemId;
    }

    try {
      final response = await _httpRequest.postRequest(
          API_APPOINTMENTS, newAppointmentData, _authToken, context);

      if (response == true) {
        status = true;
      }
      notifyListeners();
      return status;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateAppointment(
      String id, Appointment newAppointment, String type, context) async {
    var status = false;
    var newAppointmentData = {
      'customer_id': newAppointment.customerId,
      'appointment_date': newAppointment.appointmentDate,
      'status_id': newAppointment.statusId,
    };
    // print('newAppointment.servicesId');
    // print(newAppointment.servicesId);
    for (var item in newAppointment.servicesId) {
      final itemId = item['id'].toString();
      newAppointmentData['service_ids[$itemId]'] = itemId;
    }

    try {
      final response = await _httpRequest.putRequest(
        id,
        API_APPOINTMENTS,
        newAppointmentData,
        _authToken,
        context,
      );

      if (response == true) {
        status = true;
        if (type == 'recent') {
          log('recet appointments updated');
          await fetchRecentAppointment(1, context: context);
        } else if (type == 'today') {
          log('today\'s appointments updated');
          await fetchTodayAppointment(1, context: context);
        } else if (type == 'all') {
          log('all appointments updated');
          await fetchAllAppointment(1, context: context);
        }
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }

    return status;
  }

  Future<Appointment> fetchAppointmentById(String id,
      {BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(
        '$API_APPOINTMENTS/$id',
        _authToken,
        context: context,
      );

      final extractedData = json.decode(response.body)['data']['appointment'];

      final appointmentdData = Appointment(
        id: extractedData['id'].toString(),
        customerId: extractedData['customer_id'].toString(),
        servicesId: extractedData['services'],
        appointmentDate: extractedData['appointment_date'],
        statusId: extractedData['status']['id'].toString(),
        customer: extractedData['customer'],
        status: extractedData['status'],
      );

      notifyListeners();
      return appointmentdData;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteAppointment(
      String id, String type, BuildContext context) async {
    var deleteStatus = false;
    int existingAppointmentIndex;
    // ignore: prefer_typing_uninitialized_variables
    var existingAppointment;

    // var temp1= 'akshay';

    if (type == 'recent') {
      existingAppointmentIndex = _recentAppointments
          .indexWhere((appointmentData) => appointmentData.id == id);
      existingAppointment = _recentAppointments[existingAppointmentIndex];
    } else if (type == 'today') {
      existingAppointmentIndex = _todayAppointments
          .indexWhere((appointmentData) => appointmentData.id == id);
      existingAppointment = _todayAppointments[existingAppointmentIndex];
    } else {
      existingAppointmentIndex = _allAppointments
          .indexWhere((appointmentData) => appointmentData.id == id);
      existingAppointment = _allAppointments[existingAppointmentIndex];
    }

    await _httpRequest
        .deleteRequest(
      '$API_APPOINTMENTS/$id',
      _authToken,
      context,
    )
        .then((response) {
      if (json.decode(response.body)['success'] == true) {
        deleteStatus = true;

        fetchTodayCount();
        fetchAllCount();
      }
      existingAppointment = null;
    }).catchError((_) {
      if (type == 'recent') {
        _recentAppointments.insert(
            existingAppointmentIndex, existingAppointment);
      } else if (type == 'today') {
        _todayAppointments.insert(
            existingAppointmentIndex, existingAppointment);
      } else {
        _allAppointments.insert(existingAppointmentIndex, existingAppointment);
      }

      // _allAppointments.insert(existingAppointmentIndex, existingAppointment);
      notifyListeners();
      deleteStatus = false;
    });

    if (type == 'recent') {
      _recentAppointments.removeAt(existingAppointmentIndex);
    } else if (type == 'today') {
      _todayAppointments.removeAt(existingAppointmentIndex);
    } else {
      _allAppointments.removeAt(existingAppointmentIndex);
    }

    notifyListeners();
    return deleteStatus;
  }
}

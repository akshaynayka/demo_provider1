import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../values/api_end_points.dart';
import 'package:flutter/material.dart';
import '../http_request/http_request.dart';

class Address with ChangeNotifier {
  final String? id;
  final String name;
  final String? mobileNo;
  final String? addressLine1;
  final String? addressLine2;
  final String? landmark;
  final String? countryId;
  final String? stateId;
  final String? cityId;
  final String? pinCode;
  final String? defaultAddress;

  Address({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.addressLine1,
    required this.addressLine2,
    required this.landmark,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    required this.pinCode,
    this.defaultAddress,
  });
}

class Country {
  final String id;
  final String name;

  Country({
    required this.id,
    required this.name,
  });
}

class States {
  final String id;
  final String name;

  States({
    required this.id,
    required this.name,
  });
}

class City {
  final String id;
  final String name;

  City({
    required this.id,
    required this.name,
  });
}

class AddressList with ChangeNotifier {
  final HttpRequest _httpRequest = HttpRequest();
  // ignore: prefer_typing_uninitialized_variables
  final _authToken;
  List<Address> _addressList = [];
  List<Country> _countriesList = [];
  List<States> _statesList = [];
  List<City> _citiesList = [];
  AddressList(this._authToken, this._addressList);

  List<Address> get addressList {
    return [..._addressList];
  }

  List<Country> get countriesList {
    return [..._countriesList];
  }

  List<States> get statesList {
    return [..._statesList];
  }

  List<City> get citiesList {
    return [..._citiesList];
  }

  Future<bool> addAddress(Address address, context) async {
    var status = false;

    try {
      final response = await _httpRequest.postRequest(
          '$API_PROFILE/$API_ADDRESS',
          {
            'name': address.name,
            'mobile_no': address.mobileNo,
            'address_line1': address.addressLine1,
            'address_line2': address.addressLine2,
            'landmark': address.landmark,
            'country_id': address.cityId,
            'state_id': address.stateId,
            'city_id': address.cityId,
            'pin_code': address.pinCode,
          },
          _authToken,
          context);

      if (response == true) {
        status = true;
      }
      notifyListeners();

      return status;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAllAddress({BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(
          '$API_PROFILE/$API_ADDRESS', _authToken,
          context: context);

      final extractedData = json.decode(response.body);
      // print(extractedData);
      final List<Address> loadedData = [];
      for (var addressData in (extractedData['data']['addresses'] as List)) {
        loadedData.add(Address(
          id: addressData['id'].toString(),
          name: addressData['name'],
          mobileNo: addressData['mobile_no'].toString(),
          addressLine1: addressData['address_line1'],
          addressLine2: addressData['address_line2'],
          landmark: addressData['landmark'],
          countryId: addressData['country_id'].toString(),
          stateId: addressData['state_id'].toString(),
          cityId: addressData['city_id'].toString(),
          pinCode: addressData['pin_code'].toString(),
          defaultAddress: addressData['default'],
        ));
      }
      _addressList = loadedData;
      notifyListeners();
    } catch (error) {
      // log(error.toString());
      rethrow;
    }
  }

  Future<Address> fetchAddressById(id, {BuildContext? context}) async {
    
    try {
      final response = await _httpRequest.getRequest(
        '$API_PROFILE/$API_ADDRESS/$id',
        _authToken,
        context: context,
      );

      final extractedData = json.decode(response.body)['data']['address'];
      // log(extractedData.toString());
      final editedAddress = Address(
        id: extractedData['id'].toString(),
        name: extractedData['name'],
        mobileNo: extractedData['mobile_no'].toString(),
        addressLine1: extractedData['address_line1'],
        addressLine2: extractedData['address_line2'],
        landmark: extractedData['landmark'],
        countryId: extractedData['country'] == null
            ? null
            : extractedData['country']['id'].toString(),
        stateId: extractedData['state'] == null
            ? null
            : extractedData['state']['id'].toString(),
        cityId: extractedData['city'] == null
            ? null
            : extractedData['city']['id'].toString(),
        pinCode: extractedData['pin_code'].toString(),
        defaultAddress: extractedData['default'],
      );
   

      notifyListeners();
      return editedAddress;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateAddress(String? id, Address newAddress, context) async {
    // final addressIndex = _addresList.indexWhere((data) => data.id == id);

    var status = false;

    // if (addressIndex >= 0) {

    try {
      final response = await _httpRequest.putRequest(
          id!,
          '$API_PROFILE/$API_ADDRESS',
          {
            'name': newAddress.name,
            'mobile_no': newAddress.mobileNo,
            'address_line1': newAddress.addressLine1,
            'address_line2': newAddress.addressLine2,
            'landmark': newAddress.landmark,
            'country_id': newAddress.cityId,
            'state_id': newAddress.stateId,
            'city_id': newAddress.cityId,
            'pin_code': newAddress.pinCode,
          },
          _authToken,
          context);

      if (response == true) {
        status = true;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    return status;
  }

  Future<bool> dafaultAddress(String addressId, context) async {
    var status = false;

    try {
      final response = await _httpRequest.postRequest(
          '$API_PROFILE/$API_ADDRESS/$addressId/$API_DEFAULTS',
          {},
          _authToken,
          context);

      if (response == true) {
        status = true;
      }
      notifyListeners();

      return status;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteAddress(String id, context) async {
    final existingAddressIndex =
        _addressList.indexWhere((addressData) => addressData.id == id);
    Address? existingAddress = _addressList[existingAddressIndex];

    await _httpRequest
        .deleteRequest(
      '$API_PROFILE/$API_ADDRESS/$id',
      _authToken,
      context,
    )
        .then((response) {
      if (response.statusCode >= 400) {
        if (kDebugMode) {
          print('error occured!!');
        }
      }
      existingAddress = null;
    }).catchError((_) {
      _addressList.insert(existingAddressIndex, existingAddress!);
      notifyListeners();
      // return false;
    });

    _addressList.removeAt(existingAddressIndex);
    notifyListeners();

    return true;
  }

  Future<void> fetchAllcountries({BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(API_COUNTRIES, _authToken,
          context: context);

      final extractedData = json.decode(response.body);

      final List<Country> loadedData = [];
      extractedData['data']['countries']['data'].forEach((countryData) {
        loadedData.add(Country(
          id: countryData['id'].toString(),
          name: countryData['name'],
        ));
      });
      _countriesList = loadedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAllStates({BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(API_STATES, _authToken,
          context: context);

      final extractedData = json.decode(response.body);

      final List<States> loadedData = [];
      extractedData['data']['states']['data'].forEach((statusData) {
        loadedData.add(States(
          id: statusData['id'].toString(),
          name: statusData['name'],
        ));
      });
      _statesList = loadedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAllCities({BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(API_CITIES, _authToken,
          context: context);

      final extractedData = json.decode(response.body);
      final List<City> loadedData = [];
      extractedData['data']['cities'].forEach((statusData) {
        loadedData.add(City(
          id: statusData['id'].toString(),
          name: statusData['name'],
        ));
      });
      _citiesList = loadedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}

import 'package:flutter/foundation.dart';

import '../provider/address.dart';

// import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../http_request/http_request.dart';
import '../values/api_end_points.dart';

final String baseUrl = dotenv.get('API_URL');

class Customer with ChangeNotifier {
  final String? id;
  String fullName;
  String mobileNo;
  String? email;
  String? dob;
  final String gender;
  String whatsapp;
  String favorite;
  String status;

  Customer({
    required this.id,
    required this.fullName,
    required this.mobileNo,
    required this.email,
    required this.dob,
    required this.gender,
    required this.whatsapp,
    required this.favorite,
    required this.status,
  });
}

class Customers with ChangeNotifier {
  List<Customer> _allCustomers = [];
  List<Customer> _allDropdownCustomers = [];

  List<Customer> _favoriteCustomers = [];
  List<Customer> _searchCustomers = [];
  List<Address> _customerAddressList = [];

  final HttpRequest _httpRequest = HttpRequest();

  // ignore: prefer_typing_uninitialized_variables
  final _authToken;

  Customers(
    this._authToken,
    this._allCustomers,
  );

  List<Customer> get allCustomers {
    return [..._allCustomers];
  }

  List<Customer> get allDropdownCustomers {
    return [..._allDropdownCustomers];
  }

  List<Customer> get favoriteCustomers {
    return [..._favoriteCustomers];
  }

  List<Customer> get searchCustomersList {
    return [..._searchCustomers];
  }

  List<Address> get customerAddressList {
    return [..._customerAddressList];
  }

  resetCustomersWithPagination() {
    _allCustomers = [];
    _favoriteCustomers = [];
  }

  resetDropdownCustomers() {
    _allDropdownCustomers = [];
  }

  resetsearchCustomers() {
    // print('reset serchcustomer');
    _searchCustomers = [];
  }

  Future<void> rebuildWidget({BuildContext? context}) async {}

  Future<bool> toggleFavoriteStatus(
      String type, id, BuildContext ctx, String? authToken) async {
    int customerIndex;
    bool isFavorite;

    Customer tempCustomer;
    if (type == 'favorite') {
      customerIndex = _favoriteCustomers.indexWhere((data) => data.id == id);
      tempCustomer = _favoriteCustomers[customerIndex];
    } else {
      customerIndex = _allCustomers.indexWhere((data) => data.id == id);
      tempCustomer = _allCustomers[customerIndex];
    }

    final url = '$baseUrl/api/$API_CUSTOMERS/$id/favorites';

    try {
      final response = await http.post(Uri.parse(url), body: {
        // 'favorite': 'yes',
      }, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      });
      if (json.decode(response.body)['data']['customer']['favorite'] == 'yes') {
        tempCustomer.favorite = 'yes';
        isFavorite = true;
      } else {
        tempCustomer.favorite = 'no';
        isFavorite = false;
      }
      if (type == 'favorite') {
        _favoriteCustomers[customerIndex] = tempCustomer;
        _favoriteCustomers.removeAt(customerIndex);
      } else {
        _allCustomers[customerIndex] = tempCustomer;
      }

      if (type != 'favorite') {
        await fetchFavoriteCustomers(1);
      } else {
        await fetchAllCustomers(1);
      }
      notifyListeners();
      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content:
              Text(isFavorite ? 'Added to Favorite' : 'Removed from Favorite'),
          duration: const Duration(seconds: 2),
        ),
      );
      return isFavorite;
    } catch (error) {
      rethrow;

      // _setFavValue(oldStatus);
    }
    // fetchAllCustomers();
    // fetchFavoriteCustomers();
  }

  Future<Customer> fetchCustomerById(id, {BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(
        '$API_CUSTOMERS/$id',
        _authToken,
        context: context,
      );
      final extractedData = json.decode(response.body)['data']['customer'];
      final editedService = Customer(
        id: extractedData['id'].toString(),
        fullName: extractedData['full_name'].toString(),
        mobileNo: extractedData['mobile_no'],
        email: extractedData['email'],
        dob: extractedData['dob'],
        gender: extractedData['gender'],
        whatsapp: extractedData['whatsapp'],
        favorite: extractedData['favorite'],
        status: extractedData['status'],
      );

      notifyListeners();
      return editedService;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> fetchAllCustomers(int page, {BuildContext? context}) async {
    var pages = {'currentPage': 1, 'lastPage': 1};
    if (page == 1) {
      _allCustomers = [];
    }

    try {
      final response = await _httpRequest.getRequest(
        API_CUSTOMERS,
        _authToken,
        param: 'page=$page',
        context: context,
      );
      final extractedData = json.decode(response.body);
      final List<Customer> loadedData = [];
      extractedData['data']['customers']['data'].forEach((customerData) {
        loadedData.add(Customer(
          id: customerData['id'].toString(),
          fullName: customerData['full_name'].toString(),
          mobileNo: customerData['mobile_no'],
          email: customerData['email'],
          dob: customerData['dob'],
          gender: customerData['gender'],
          whatsapp: customerData['whatsapp'],
          favorite: customerData['favorite'],
          status: customerData['status'],
        ));
      });
      _allCustomers = _allCustomers + loadedData;
      pages['currentPage'] = extractedData['data']['customers']['current_page'];
      pages['lastPage'] = extractedData['data']['customers']['last_page'];
      notifyListeners();
      return pages;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> fetchAllDropdownCustomers(int page,
      {BuildContext? context}) async {
    var pages = {'currentPage': 1, 'lastPage': 1};
    if (page == 1) {
      _allDropdownCustomers = [];
    }

    try {
      final response = await _httpRequest.getRequest(
        API_CUSTOMERS,
        _authToken,
        param: 'page=$page',
        context: context,
      );
      final extractedData = json.decode(response.body);
      final List<Customer> loadedData = [];
      extractedData['data']['customers']['data'].forEach((customerData) {
        loadedData.add(Customer(
          id: customerData['id'].toString(),
          fullName: customerData['full_name'].toString(),
          mobileNo: customerData['mobile_no'],
          email: customerData['email'],
          dob: customerData['dob'],
          gender: customerData['gender'],
          whatsapp: customerData['whatsapp'],
          favorite: customerData['favorite'],
          status: customerData['status'],
        ));
      });
      _allDropdownCustomers = _allDropdownCustomers + loadedData;
      pages['currentPage'] = extractedData['data']['customers']['current_page'];
      pages['lastPage'] = extractedData['data']['customers']['last_page'];
      notifyListeners();
      return pages;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> fetchFavoriteCustomers(int page, {BuildContext? context}) async {
    var pages = {'currentPage': 1, 'lastPage': 1};
    if (page == 1) {
      _favoriteCustomers = [];
    }

    try {
      final response = await _httpRequest.getRequest(
        API_CUSTOMERS,
        _authToken,
        param: 'favorite=yes&page=$page',
        context: context,
      );

      final extractedData = json.decode(response.body);
      final List<Customer> loadedData = [];

      extractedData['data']['customers']['data'].forEach((customerData) {
        loadedData.add(Customer(
          id: customerData['id'].toString(),
          fullName: customerData['full_name'].toString(),
          mobileNo: customerData['mobile_no'],
          email: customerData['email'],
          dob: customerData['dob'],
          gender: customerData['gender'],
          whatsapp: customerData['whatsapp'],
          favorite: customerData['favorite'],
          status: customerData['status'],
        ));
      });

      _favoriteCustomers = _favoriteCustomers + loadedData;
      pages['currentPage'] = extractedData['data']['customers']['current_page'];
      pages['lastPage'] = extractedData['data']['customers']['last_page'];
      notifyListeners();
      return pages;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> searchCustomers(String searchText, int page,
      {BuildContext? context}) async {
    var pages = {'currentPage': 1, 'lastPage': 1};
    if (page == 1) {
      _searchCustomers = [];
    }

    try {
      final response = await _httpRequest.getRequest(
        API_CUSTOMERS,
        _authToken,
        param: 'search_txt=%$searchText%&page=$page',
        // search_txt=customer 1
        context: context,
      );

      final extractedData = json.decode(response.body);

      final List<Customer> loadedData = [];
      extractedData['data']['customers']['data'].forEach((customerData) {
        loadedData.add(Customer(
          id: customerData['id'].toString(),
          fullName: customerData['full_name'].toString(),
          mobileNo: customerData['mobile_no'],
          email: customerData['email'],
          dob: customerData['dob'],
          gender: customerData['gender'],
          whatsapp: customerData['whatsapp'],
          favorite: customerData['favorite'],
          status: customerData['status'],
        ));
      });
      _searchCustomers = _searchCustomers + loadedData;
      pages['currentPage'] = extractedData['data']['customers']['current_page'];
      pages['lastPage'] = extractedData['data']['customers']['last_page'];
      notifyListeners();
      return pages;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> addCustomer(Customer customer, context) async {
    var status = false;

    try {
      final response = await _httpRequest.postRequest(
          API_CUSTOMERS,
          {
            'full_name': customer.fullName,
            'mobile_no': customer.mobileNo,
            'email': customer.email,
            'dob': customer.dob,
            'gender': customer.gender,
            'whatsapp': customer.whatsapp,
            'favorite': customer.favorite,
            'status': customer.status,
          },
          _authToken,
          context);

      if (response == true) {
        status = true;
        await fetchFavoriteCustomers(1);
        await fetchAllCustomers(1);
      }
      // resetCustomersWithPagination();
      notifyListeners();
      return status;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateCustomer(
      String? id, Customer newCustomer, BuildContext context) async {
    var status = false;

    try {
      final response = await _httpRequest.putRequest(
          id!,
          API_CUSTOMERS,
          {
            'full_name': newCustomer.fullName,
            'mobile_no': newCustomer.mobileNo,
            'email': newCustomer.email,
            'dob': newCustomer.dob,
            'gender': newCustomer.gender,
            'whatsapp': newCustomer.whatsapp,
            'favorite': newCustomer.favorite,
            'status': newCustomer.status,
          },
          _authToken,
          context);
      // print('$response --??????????????????????');
      if (response == true) {
        status = true;
        await fetchFavoriteCustomers(1);
        await fetchAllCustomers(1);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    return status;
  }

  Future<bool> deleteCustomer(
      String id, String type, BuildContext context) async {
    // ignore: prefer_typing_uninitialized_variables
    var existingCustomer;
    int existingCustomerIndex;
    if (type == 'favorite') {
      existingCustomerIndex = _favoriteCustomers
          .indexWhere((customerData) => customerData.id == id);
      existingCustomer = _favoriteCustomers[existingCustomerIndex];
    } else {
      existingCustomerIndex =
          _allCustomers.indexWhere((customerData) => customerData.id == id);
      existingCustomer = _allCustomers[existingCustomerIndex];
    }

    await _httpRequest
        .deleteRequest(
      '$API_CUSTOMERS/$id',
      _authToken,
      context,
    )
        .then((response) {
      if (response.statusCode >= 400) {
        if (kDebugMode) {
          print('error occured!!');
        }
      }
      existingCustomer = null;
    }).catchError((_) {
      if (type == 'favorite') {
        _favoriteCustomers.insert(existingCustomerIndex, existingCustomer);
      } else {
        _allCustomers.insert(existingCustomerIndex, existingCustomer);
      }

      // _allCustomers.insert(existingCustomerIndex, existingCustomer);
      notifyListeners();
      // return false;
    });

    if (type == 'favorite') {
      _favoriteCustomers.removeAt(existingCustomerIndex);
      await fetchAllCustomers(1);
    } else {
      _allCustomers.removeAt(existingCustomerIndex);
      await fetchAllCustomers(1);
      await fetchFavoriteCustomers(1);
    }

    // _allCustomers.removeAt(existingCustomerIndex);
    notifyListeners();
    // fetchFavoriteCustomers();

    return true;
  }

  Future<void> fetchCustomerAddress(String id, {BuildContext? context}) async {
    try {
      // customers/1/address
      final response = await _httpRequest.getRequest(
          '$API_CUSTOMERS/$id/$API_ADDRESS', _authToken,
          context: context);

      final extractedData = json.decode(response.body);

      final List<Address> loadedData = [];
      extractedData['data']['addresses']['data'].forEach((addressData) {
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
      });
      _customerAddressList = loadedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<Address> fetchCustomerAddressById(String customerId, String addressId,
      {BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(
        '$API_CUSTOMERS/$customerId/$API_ADDRESS/$addressId',
        _authToken,
        context: context,
      );

      final extractedData = json.decode(response.body)['data']['address'];

      final editedAddress = Address(
        id: extractedData['id'].toString(),
        name: extractedData['name'],
        mobileNo: extractedData['mobile_no'].toString(),
        addressLine1: extractedData['address_line1'],
        addressLine2: extractedData['address_line2'],
        landmark: extractedData['landmark'],
        countryId: extractedData['country']['id'].toString(),
        stateId: extractedData['state']['id'].toString(),
        cityId: extractedData['city']['id'].toString(),
        pinCode: extractedData['pin_code'].toString(),
        defaultAddress: extractedData['default'],
      );

      notifyListeners();
      return editedAddress;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> addCustomerAddress(
      String id, Address address, BuildContext context) async {
    var status = false;

    try {
      final response = await _httpRequest.postRequest(
          '$API_CUSTOMERS/$id/$API_ADDRESS',
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

  Future<bool> dafaultCustomerAddress(
      String id, String addressId, BuildContext context) async {
    var status = false;

    try {
      final response = await _httpRequest.postRequest(
          '$API_CUSTOMERS/$id/$API_ADDRESS/$addressId/$API_DEFAULTS',
          // {{url}}customers/1/address/14/defaults
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

  Future<bool> updateCustomerAddress(String customerId, String addressId,
      Address newAddress, BuildContext context) async {
    var status = false;

    try {
      final response = await _httpRequest.putRequest(
          addressId,
          '$API_CUSTOMERS/$customerId/$API_ADDRESS',
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

  Future<bool> deleteCustomerAddress(
      String customerId, String addressId, BuildContext context) async {
    final existingAddressIndex = _customerAddressList
        .indexWhere((addressData) => addressData.id == addressId);
    Address? existingAddress = _customerAddressList[existingAddressIndex];

    await _httpRequest
        .deleteRequest(
      '$API_CUSTOMERS/$customerId/$API_ADDRESS/$addressId',
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
      _customerAddressList.insert(existingAddressIndex, existingAddress!);
      notifyListeners();
      // return false;
    });

    _customerAddressList.removeAt(existingAddressIndex);
    notifyListeners();

    return true;
  }
}

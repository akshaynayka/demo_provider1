import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../values/api_end_points.dart';
import '../http_request/http_request.dart';

final String baseUrl = dotenv.get('API_URL');

class Service with ChangeNotifier {
  final String? id;
  final String name;
  final String? description;
  final String price;
  String favorite;

  String status;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.status,
    required this.favorite,
  });
}

class Services with ChangeNotifier {
  List<Service> _services = [];
  List<Service> _dropdownServices = [];
  List<Service> _favoriteServices = [];
  final HttpRequest _httpRequest = HttpRequest();
  List<Service> _searchServices = [];

  // ignore: prefer_typing_uninitialized_variables
  final _authToken;
  Services(
    this._authToken,
    this._services,
  );

  List<Service> get services {
    return [..._services];
  }

  List<Service> get dropdownServices {
    return [..._dropdownServices];
  }

  List<Service> get favoriteServices {
    return [..._favoriteServices];
  }

  List<Service> get searchServicesList {
    return [..._searchServices];
  }

  Future<void> rebuildWidget({BuildContext? context}) async {
    // print('---calling rebuild---');
  }

  void resetServicesWithPagination() {
    _services = [];
    _favoriteServices = [];
  }

  void resetDropdownServices() {
    _dropdownServices = [];
  }

  void resetsearchServices() {
    _searchServices = [];
  }

  Future<bool> toggleFavoriteStatus(
      String type, id, BuildContext ctx, String authToken) async {
    int serviceIndex;
    bool isFavorite = false;

    Service tempService;

    final url = '$baseUrl/api/$API_SERVICES/$id/favorites';

    try {
      final response = await http.post(Uri.parse(url), body: {
        // 'favorite': 'yes',
      }, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      });
      if (type == 'favorite') {
        serviceIndex = _favoriteServices.indexWhere((data) => data.id == id);
        tempService = _favoriteServices[serviceIndex];
      } else {
        serviceIndex = _services.indexWhere((data) => data.id == id);
        tempService = _services[serviceIndex];
      }

      if (json.decode(response.body)['data']['service']['favorite'] == 'yes') {
        tempService.favorite = 'yes';
        isFavorite = true;
      } else {
        tempService.favorite = 'no';
        isFavorite = false;
      }

      if (type == 'favorite') {
        _favoriteServices[serviceIndex] = tempService;
        _favoriteServices.removeAt(serviceIndex);
      } else {
        _services[serviceIndex] = tempService;
      }

      if (type != 'favorite') {
        await fetchFavoriteService(1);
      } else {
        await fetchAllService(1);
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
      return isFavorite;
      // _setFavValue(oldStatus);
    }

    // fetchAllCustomers();
    // fetchFavoriteCustomers();
  }

  Future<Service> fetchServiceById(id, {BuildContext? context}) async {
    try {
      final response = await _httpRequest.getRequest(
        '$API_SERVICES/$id',
        _authToken,
        context: context,
      );

      final extractedData = json.decode(response.body)['data']['service'];

      final editedService = Service(
        id: extractedData['id'].toString(),
        name: extractedData['name'],
        description: extractedData['description'],
        price: extractedData['price'].toString(),
        favorite: extractedData['favorite'],
        status: extractedData['status'],
      );

      notifyListeners();
      return editedService;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> searchServices(String searchText, int page,
      {BuildContext? context}) async {
    var pages = {'currentPage': 1, 'lastPage': 1};
    if (page == 1) {
      _searchServices = [];
    }

    try {
      final response = await _httpRequest.getRequest(
        API_SERVICES,
        _authToken,
        param: 'search_txt=%$searchText%&page=$page',
        context: context,
      );

      final extractedData = json.decode(response.body);

      final List<Service> loadedData = [];
      extractedData['data']['services']['data'].forEach((serviceData) {
        loadedData.add(Service(
          id: serviceData['id'].toString(),
          name: serviceData['name'],
          description: serviceData['description'],
          price: serviceData['price'].toString(),
          favorite: serviceData['favorite'],
          status: serviceData['status'],
        ));
      });
      _searchServices = _searchServices + loadedData;
      pages['currentPage'] = extractedData['data']['customers']['current_page'];
      pages['lastPage'] = extractedData['data']['customers']['last_page'];
      notifyListeners();
      return pages;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> fetchAllService(int page, {BuildContext? context}) async {
    var pages = {'currentPage': 1, 'lastPage': 1};
    int i = 1;
    log('1st lvl');
    log(_services.length.toString());
    if (page == 1) {
      _services = [];
    }
    log('2nd lvl');
    log(_services.length.toString());
    log('i $i');
    i++;
    try {
      final response = await _httpRequest.getRequest(
        API_SERVICES,
        _authToken,
        param: 'page=$page',
        context: context,
      );

      final extractedData = json.decode(response.body);

      final List<Service> loadedData = [];
      extractedData['data']['services']['data'].forEach((serviceData) {
        loadedData.add(Service(
          id: serviceData['id'].toString(),
          name: serviceData['name'],
          description: serviceData['description'] ?? '',
          price: serviceData['price'].toString(),
          favorite: serviceData['favorite'],
          status: serviceData['status'],
        ));
      });
      _services = _services + loadedData;
      log('3rd lvl & loadeddata : ${loadedData.length} and _services : ${_services.length}');
      log(_services.length.toString());
      pages['currentPage'] = extractedData['data']['services']['current_page'];
      pages['lastPage'] = extractedData['data']['services']['last_page'];

      log('i $i');
      i++;
      notifyListeners();
      return pages;
    } catch (error) {
      log('i $i');
      i++;
      rethrow;
    }
  }

  Future<Map> fetchAllDropdownService(int page, {BuildContext? context}) async {
    var pages = {'currentPage': 1, 'lastPage': 1};
    if (page ==1) {
      _dropdownServices = [];
    }

    try {
      final response = await _httpRequest.getRequest(
        API_SERVICES,
        _authToken,
        param: 'page=$page',
        context: context,
      );

      final extractedData = json.decode(response.body);

      final List<Service> loadedData = [];
      extractedData['data']['services']['data'].forEach((serviceData) {
        loadedData.add(Service(
          id: serviceData['id'].toString(),
          name: serviceData['name'],
          description: serviceData['description'] ?? '',
          price: serviceData['price'].toString(),
          favorite: serviceData['favorite'],
          status: serviceData['status'],
        ));
      });
      _dropdownServices = _dropdownServices + loadedData;
      pages['currentPage'] = extractedData['data']['services']['current_page'];
      pages['lastPage'] = extractedData['data']['services']['last_page'];
      notifyListeners();
      return pages;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> fetchFavoriteService(int page, {BuildContext? context}) async {
    var pages = {'currentPage': 1, 'lastPage': 1};
    if (page == 1) {
      _favoriteServices = [];
    }

    try {
      final response = await _httpRequest.getRequest(
        API_SERVICES,
        _authToken,
        param: 'favorite=yes&page=$page',
        context: context,
      );

      final extractedData = json.decode(response.body);
      final List<Service> loadedData = [];
      extractedData['data']['services']['data'].forEach((serviceData) {
        loadedData.add(
          Service(
            id: serviceData['id'].toString(),
            name: serviceData['name'],
            description: serviceData['description'],
            price: serviceData['price'].toString(),
            favorite: serviceData['favorite'],
            status: serviceData['status'],
          ),
        );
      });
      log('fav : ${_favoriteServices.length} & loadedData : ${loadedData.length} ');
      _favoriteServices = _favoriteServices + loadedData;

      pages['currentPage'] = extractedData['data']['services']['current_page'];
      pages['lastPage'] = extractedData['data']['services']['last_page'];
      notifyListeners();
      return pages;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> addService(Service service, context) async {
    var status = false;
    try {
      final response = await _httpRequest.postRequest(
          API_SERVICES,
          {
            'name': service.name,
            'description': service.description,
            'price': service.price,
            'favorite': service.favorite,
            'status': service.status,
          },
          _authToken,
          context);

      if (response == true) {
        if (service.favorite == 'yes') {
          await fetchAllService(1);
          await fetchFavoriteService(1);
        } else if (service.favorite == 'no') {
          await fetchAllService(1);
        }
        status = true;
      }
      notifyListeners();
      return status;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateService(String id, Service newService, context) async {
    var status = false;

    try {
      final response = await _httpRequest.putRequest(
          id,
          API_SERVICES,
          {
            'name': newService.name,
            'description': newService.description,
            'price': newService.price,
            'favorite': newService.favorite,
            'status': newService.status,
          },
          _authToken,
          context);

      if (response == true) {
        await fetchAllService(1);
        await fetchFavoriteService(1);
        status = true;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    return status;
  }

  deleteService(String id, String type, context) async {
    var deleteStatus = false;
    int existingServiceIndex;
    // ignore: prefer_typing_uninitialized_variables
    var existingService;

    if (type == 'favorite') {
      existingServiceIndex =
          _favoriteServices.indexWhere((serviceData) => serviceData.id == id);
      existingService = _favoriteServices[existingServiceIndex];
    } else {
      existingServiceIndex =
          _services.indexWhere((serviceData) => serviceData.id == id);
      existingService = _services[existingServiceIndex];
    }

    await _httpRequest
        .deleteRequest(
      '$API_SERVICES/$id',
      _authToken,
      context,
    )
        .then((response) async {
      if (json.decode(response.body)['success'] == true) {
        deleteStatus = true;
        if (type == 'favorite') {
          await fetchAllService(1);
          await fetchFavoriteService(1);
        } else {
          await fetchFavoriteService(1);
        }
      } else {
        if (kDebugMode) {
          print('error occured!!');
        }
      }

      if (response.statusCode >= 400) {
        if (kDebugMode) {
          print('error occured!!');
        }
      }
      existingService = null;
    }).catchError((_) {
      if (type == 'favorite') {
        _favoriteServices.insert(existingServiceIndex, existingService);
      } else {
        _services.insert(existingServiceIndex, existingService);
      }
      notifyListeners();
      deleteStatus = false;
    });

    if (type == 'favorite') {
      _favoriteServices.removeAt(existingServiceIndex);
    } else {
      _services.removeAt(existingServiceIndex);
    }
    notifyListeners();
    return deleteStatus;
  }
}
